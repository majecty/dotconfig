use whichkey::config::Config;
use slint::*;
use std::process::Command as StdCommand;
use std::rc::Rc;
use std::cell::RefCell;

slint::include_str!("../whichkey.slint");

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

    let ui = AppWindow::new().unwrap();
    
    // Convert config to UI model
    let mut items: Vec<KeyItem> = config.keybindings.iter()
        .map(|(key, binding)| KeyItem {
            key: key.into(),
            description: binding.description.clone().into(),
        })
        .collect();

    let model = VecModel::from(items);
    ui.set_items(Rc::new(model));

    // Handle key presses
    let config_rc = Rc::new(RefCell::new(config));
    let config_clone = config_rc.clone();
    
    ui.window().set_key_pressed(move |event| {
        if let Ok(key_text) = std::str::from_utf8(event.text.as_bytes()) {
            let cfg = config_clone.borrow();
            if let Some(binding) = cfg.keybindings.get(key_text) {
                let _ = StdCommand::new("sh")
                    .arg("-c")
                    .arg(&binding.command)
                    .spawn();
                std::process::exit(0);
            }
        }
        EventResult::EventAccepted
    });

    // Close on Escape
    let close_window = ui.as_weak();
    ui.on_escape(move || {
        std::process::exit(0);
    });

    ui.run().unwrap();
}
