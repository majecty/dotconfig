define-command -params 0..1 aichat-current-buffer %{
    evaluate-commands %sh{
        tmpfile=$(mktemp)
        echo "INFO: Starting aichat commit process."
        echo "INFO: Temporary file created at $tmpfile."
        # 버퍼 내용을 임시파일에 저장
        kakoune -f 'write!' $tmpfile

        # git diff 결과를 임시파일에 저장
        git diff --cached > $tmpfile

        # aichat로 임시파일 내용 전송
        result=$(cat $tmpfile | aichat -r commit)
        kakoune -e "replace-buffer" <<< "$result"
        rm $tmpfile
    }
}

# Add user keymap for aichat command
map global user -docstring 'ai commit message' c ':aichat-current-buffer<ret>'
