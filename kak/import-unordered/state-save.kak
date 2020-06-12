
hook global KakBegin .* %{
    state-save-reg-sync colon
    state-save-reg-sync pipe
    state-save-reg-sync slash
}
hook global KakEnd .* %{
    state-save-reg-sync colon
    state-save-reg-sync pipe
    state-save-reg-sync slash
}
