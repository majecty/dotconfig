package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"gopkg.in/ini.v1"

	"os/exec"
)

func main() {
	var (
		baseProfile   string
		targetProfile string
		mfaArn        string
		duration      int64
		mfaCode       string
	)

	baseProfile = "jh"
	targetProfile = "work"
	mfaArn = "arn:aws:iam::904436162969:mfa/1passwod-totp"
	duration = 3600

	// mfa code를 `op item get syn6cp4jkimysakj4zjrwp7vhe --otp` 로 알아내기
	cmd := exec.Command("op", "item", "get", "syn6cp4jkimysakj4zjrwp7vhe", "--otp")
	output, err := cmd.Output()
	if err != nil {
		log.Fatalf("failed to get MFA code from 1Password: %v", err)
	}
	mfaCode = string(output)
	// Remove trailing newline if present
	if len(mfaCode) > 0 && mfaCode[len(mfaCode)-1] == '\n' {
		mfaCode = mfaCode[:len(mfaCode)-1]
	}

	ctx := context.Background()

	region := "ap-northeast-2"
	// 1) baseProfile 로 config 로드 (여기에 AdminUser 장기 키가 있어야 함)
	cfg, err := config.LoadDefaultConfig(ctx,
		config.WithSharedConfigProfile(baseProfile),
		config.WithRegion(region),
	)
	if err != nil {
		log.Fatalf("failed to load AWS config for profile %s: %v", baseProfile, err)
	}

	stsClient := sts.NewFromConfig(cfg)

	// 2) STS GetSessionToken 호출
	input := &sts.GetSessionTokenInput{
		DurationSeconds: aws.Int32(int32(duration)),
		SerialNumber:    aws.String(mfaArn),
		TokenCode:       aws.String(mfaCode),
	}

	resp, err := stsClient.GetSessionToken(ctx, input)
	if err != nil {
		log.Fatalf("failed to get session token: %v", err)
	}

	creds := resp.Credentials
	if creds == nil {
		log.Fatal("no credentials in GetSessionToken response")
	}

	fmt.Printf("Got session token. Expires at: %s\n", creds.Expiration.Format(time.RFC3339))

	// 3) ~/.aws/credentials 파일 로드/갱신
	credPath := filepath.Join(os.Getenv("HOME"), ".aws", "credentials")

	// 파일 없으면 새로 만들고, 있으면 로드
	var cfgFile *ini.File
	if _, err := os.Stat(credPath); os.IsNotExist(err) {
		cfgFile = ini.Empty()
	} else {
		cfgFile, err = ini.Load(credPath)
		if err != nil {
			log.Fatalf("failed to load %s: %v", credPath, err)
		}
	}

	// targetProfile 섹션 가져오기 (없으면 생성)
	section, err := cfgFile.GetSection(targetProfile)
	if err != nil {
		section, err = cfgFile.NewSection(targetProfile)
		if err != nil {
			log.Fatalf("failed to create section [%s]: %v", targetProfile, err)
		}
	}

	section.Key("aws_access_key_id").SetValue(aws.ToString(creds.AccessKeyId))
	section.Key("aws_secret_access_key").SetValue(aws.ToString(creds.SecretAccessKey))
	section.Key("aws_session_token").SetValue(aws.ToString(creds.SessionToken))

	if err := os.MkdirAll(filepath.Dir(credPath), 0700); err != nil {
		log.Fatalf("failed to create dir %s: %v", filepath.Dir(credPath), err)
	}

	if err := cfgFile.SaveTo(credPath); err != nil {
		log.Fatalf("failed to save credentials file: %v", err)
	}

	fmt.Printf("Updated profile [%s] in %s\n", targetProfile, credPath)
	fmt.Printf("Use it with: aws sts get-caller-identity --profile %s\n", targetProfile)
}
