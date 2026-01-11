use anyhow::Result;
use clap::{Arg, Command};
use reqwest::Client;
use serde::{Deserialize, Serialize};
use std::fs;
use std::process;
use tokio;

#[derive(Serialize)]
struct OpenRouterRequest {
    model: String,
    messages: Vec<Message>,
    max_tokens: u32,
}

#[derive(Serialize, Deserialize)]
struct Message {
    role: String,
    content: String,
}

#[derive(Deserialize)]
struct OpenRouterResponse {
    choices: Vec<Choice>,
}

#[derive(Deserialize)]
struct Choice {
    message: Message,
}

#[derive(Deserialize)]
struct Config {
    api_key: Option<String>,
}

fn read_api_key_from_config() -> Result<Option<String>> {
    let config_path = dirs::home_dir()
        .ok_or_else(|| anyhow::anyhow!("Could not determine home directory"))?
        .join(".config/commit-helper/config.toml");
    
    if !config_path.exists() {
        return Ok(None);
    }
    
    let config_content = fs::read_to_string(&config_path)?;
    let config: Config = toml::from_str(&config_content)?;
    
    Ok(config.api_key)
}

async fn get_git_diff() -> Result<String> {
    let output = process::Command::new("git")
        .args(&["diff", "--cached"])
        .output()?;
    
    if !output.status.success() {
        anyhow::bail!("Failed to get git diff");
    }
    
    Ok(String::from_utf8(output.stdout)?)
}

async fn generate_commit_message(diff: &str, api_key: &str) -> Result<String> {
    let client = Client::new();
    
    let request = OpenRouterRequest {
        model: "allenai/olmo-3.1-32b-instruct".to_string(),
        messages: vec![
            Message {
                role: "system".to_string(),
                content: "You are a helpful assistant that generates concise, clear git commit messages based on code diffs. Follow conventional commit format when appropriate. Output ONLY the commit message itself, without any explanations, markdown formatting, or conversational text.".to_string(),
            },
            Message {
                role: "user".to_string(),
                content: format!("Generate a commit message for this diff:\n\n{}", diff),
            },
        ],
        max_tokens: 100,
    };
    
    let response = client
        .post("https://openrouter.ai/api/v1/chat/completions")
        .header("Authorization", format!("Bearer {}", api_key))
        .header("Content-Type", "application/json")
        .json(&request)
        .send()
        .await?;
    
    let response_body: OpenRouterResponse = response.json().await?;
    
    if let Some(choice) = response_body.choices.first() {
        Ok(choice.message.content.trim().to_string())
    } else {
        anyhow::bail!("No response from API")
    }
}

async fn interactive_commit_flow(api_key: &str) -> Result<()> {
    // Get git diff
    let diff = get_git_diff().await?;
    if diff.trim().is_empty() {
        println!("No staged changes found. Use 'git add' to stage files first.");
        return Ok(());
    }
    
    // Generate initial commit message
    println!("Generating commit message...");
    let mut commit_message = generate_commit_message(&diff, api_key).await?;
    
    loop {
        println!("\nProposed commit message:");
        println!("------------------------");
        println!("{}", commit_message);
        println!("------------------------");
        
        println!("\nOptions: 1. Accept and commit  2. Edit message  3. Regenerate  4. Cancel");
        
        print!("Choose (1-4): ");
        use std::io::{self, Write};
        io::stdout().flush()?;
        
        let mut input = String::new();
        io::stdin().read_line(&mut input)?;
        
        match input.trim() {
            "1" => {
                // Commit with the message
                let output = process::Command::new("git")
                    .args(&["commit", "-m", &commit_message])
                    .output()?;
                
                if output.status.success() {
                    println!("✅ Committed successfully!");
                } else {
                    println!("❌ Commit failed: {}", String::from_utf8_lossy(&output.stderr));
                }
                break;
            }
            "2" => {
                // Open editor to edit the commit message
                commit_message = edit_commit_message(&commit_message).await?;
            }
            "3" => {
                println!("Regenerating commit message...");
                commit_message = generate_commit_message(&diff, api_key).await?;
            }
            "4" => {
                println!("Cancelled.");
                break;
            }
            _ => {
                println!("Invalid option. Please choose 1-4.");
            }
        }
    }
    
    Ok(())
}

async fn edit_commit_message(message: &str) -> Result<String> {
    // Create a temporary file with the current commit message
    let mut temp_file = std::env::temp_dir();
    temp_file.push("commit_message.txt");
    
    fs::write(&temp_file, message)?;
    
    // Get the editor from environment variable or default to 'nano'
    let editor = std::env::var("EDITOR").unwrap_or_else(|_| "nano".to_string());
    
    // Open the editor
    let status = process::Command::new(&editor)
        .arg(&temp_file)
        .status()?;
    
    if !status.success() {
        anyhow::bail!("Editor exited with non-zero status");
    }
    
    // Read the edited message
    let edited_message = fs::read_to_string(&temp_file)?;
    
    // Clean up the temporary file
    fs::remove_file(&temp_file)?;
    
    Ok(edited_message.trim().to_string())
}

#[tokio::main]
async fn main() -> Result<()> {
    let matches = Command::new("commit-helper")
        .about("AI-powered git commit message generator")
        .arg(
            Arg::new("api-key")
                .long("api-key")
                .value_name("KEY")
                .help("OpenRouter API key")
                .required(false),
        )
        .get_matches();
    
    let api_key = matches
        .get_one::<String>("api-key")
        .map(|s| s.to_string())
        .or_else(|| std::env::var("OPENROUTER_API_KEY").ok())
        .or_else(|| read_api_key_from_config().ok().flatten())
        .ok_or_else(|| anyhow::anyhow!("API key must be provided via --api-key, OPENROUTER_API_KEY environment variable, or ~/.config/commit-helper/config.toml"))?;
    
    interactive_commit_flow(&api_key).await?;
    
    Ok(())
}
