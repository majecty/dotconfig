use whichkey::config::Config;
use iced::{
    alignment, executor, widget::{column, container, row, text}, Alignment, Application, Command, Element, Length, Settings, Theme,
};
use std::process::Command as StdCommand;

pub fn main() -> iced::Result {
    WhichKey::run(Settings::default())
}

struct WhichKey {
    config: Config,
    selected: Option<usize>,
}

#[derive(Debug, Clone)]
enum Message {
    SelectKey(usize),
    ExecuteKey(usize),
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

        (
            WhichKey {
                config,
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
            Message::SelectKey(idx) => {
                self.selected = Some(idx);
                Command::none()
            }
            Message::ExecuteKey(idx) => {
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
}
