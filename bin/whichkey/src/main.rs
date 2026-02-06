mod config;

use config::Config;
use fltk::{prelude::*, *};
use std::process::Command;
use std::sync::{Arc, Mutex};

fn main() {
    let config_path = std::env::var("WHICHKEY_CONFIG")
        .unwrap_or_else(|_| "config.toml".to_string());

    let config = match Config::load(&config_path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Failed to load config: {}", e);
            std::process::exit(1);
        }
    };

    let app = app::App::default();
    let mut wind = window::Window::default()
        .with_size(400, 300)
        .with_label("Which-Key");
    
    let mut col = group::Flex::default()
        .with_size(400, 300)
        .column();

    let mut browser = browser::Browser::default();
    
    // Build menu text
    let mut max_key_len = 0;
    for key in config.keybindings.keys() {
        if key.len() > max_key_len {
            max_key_len = key.len();
        }
    }

    for (key, binding) in &config.keybindings {
        let padding = " ".repeat(max_key_len - key.len() + 2);
        browser.add(&format!("{}{}{}", key, padding, binding.description));
    }

    col.end();
    wind.end();

    let (sw, sh) = app::screen_size();
    let (sw, sh) = (sw as i32, sh as i32);
    // Center window on screen
    wind.set_pos(
        (sw - 400) / 2,
        (sh - 300) / 2,
    );
    wind.show();

    let config_clone = Arc::new(Mutex::new(config));

    while app.wait() {
        if let Some(selection) = browser.selected_text() {
            let key = selection.split_whitespace().next().unwrap_or("");
            let config = config_clone.lock().unwrap();
            
            if let Some(binding) = config.keybindings.get(key) {
                // Execute command silently
                let _ = Command::new("sh")
                    .arg("-c")
                    .arg(&binding.command)
                    .spawn();
                std::process::exit(0);
            }
        }
    }
}
