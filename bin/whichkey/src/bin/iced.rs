use whichkey::config::Config;
use iced::{
    executor, keyboard, widget::{column, container, row, text}, Alignment, Application, Command, Element, Length, Settings, Subscription, Theme,
};
use std::process::Command as StdCommand;
use std::sync::OnceLock;

pub fn main() -> iced::Result {
    WhichKey::run(Settings::default())
}

struct WhichKey {
    config: Config,
    keys_list: Vec<(String, String)>, // (key, command)
    selected: Option<usize>,
}

static GLOBAL_KEYS: OnceLock<Vec<(String, String)>> = OnceLock::new();

fn key_press_handler(key: keyboard::Key, _modifiers: keyboard::Modifiers) -> Option<Message> {
    match key {
        keyboard::Key::Character(c) => {
            let keys = GLOBAL_KEYS.get()?;
            if let Some(_idx) = keys.iter().position(|(k, _)| k == c.as_str()) {
                // send raw key event; execution will be handled in update
                Some(Message::KeyPressed(keyboard::Key::Character(c.clone()), _modifiers))
            } else {
                Some(Message::KeyPressed(keyboard::Key::Character(c.clone()), _modifiers))
            }
        }
        keyboard::Key::Named(keyboard::key::Named::Escape) => {
            std::process::exit(0);
        }
        _ => Some(Message::KeyPressed(key, _modifiers)),
    }
}

#[derive(Debug, Clone)]
enum Message {
    KeyPressed(keyboard::Key, keyboard::Modifiers),
}

impl Application for WhichKey {
    type Message = Message;
    type Theme = Theme;
    type Executor = executor::Default;
    type Flags = ();

    fn new(_flags: Self::Flags) -> (Self, Command<Message>) {
        let config_path = std::env::var("WHICHKEY_CONFIG")
            .unwrap_or_else(|_| "config.toml".to_string());

        let config = match Config::load(&config_path) {
            Ok(c) => c,
            Err(e) => {
                eprintln!("Failed to load config: {}", e);
                std::process::exit(1);
            }
        };

        let keys_list: Vec<(String, String)> = config.keybindings.iter()
            .map(|(k, v)| (k.clone(), v.command.clone()))
            .collect();

        let _ = GLOBAL_KEYS.set(keys_list.clone());

        (
            WhichKey {
                config,
                keys_list,
                selected: None,
            },
            Command::none(),
        )
    }

    fn title(&self) -> String {
        String::from("Which-Key")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::KeyPressed(key, _mods) => {
                match key {
                    keyboard::Key::Character(c) => {
                        let keys = GLOBAL_KEYS.get();
                        if let Some(keys) = keys {
                            if let Some(idx) = keys.iter().position(|(k, _)| k == c.as_str()) {
                                if let Some((_, binding)) = self.config.keybindings.iter().nth(idx) {
                                    let _ = StdCommand::new("sh")
                                        .arg("-c")
                                        .arg(&binding.command)
                                        .spawn();
                                }
                                std::process::exit(0);
                            }
                        }
                    }
                    _ => {}
                }
                Command::none()
            }
        }
    }

    fn view(&self) -> Element<Message> {
        let mut items = column!();

        for (idx, (key, binding)) in self.config.keybindings.iter().enumerate() {
            let item = row![
                text(format!(" {} ", key)).width(Length::Fixed(40.0)),
                text(&binding.description),
            ]
            .spacing(10)
            .padding(10)
            .align_items(Alignment::Center);

            let button = if self.selected == Some(idx) {
                container(item)
                    .style(iced::widget::container::Appearance::default())
                    .padding(5)
            } else {
                container(item).padding(5)
            };

            items = items.push(button);
        }

        let content = container(items)
            .padding(20)
            .center_x()
            .center_y();

        Element::from(content)
    }

    fn theme(&self) -> Theme {
        Theme::Dark
    }

    fn subscription(&self) -> Subscription<Message> {
        keyboard::on_key_press(key_press_handler)
    }
}
