# AR Pylos game

> AR Pylos is a 2 players multiplayer AR game. The rules of original game https://en.wikipedia.org/wiki/Pylos_(board_game).

### Features
  
  - ARKit 3
  - SwiftUI 
  - RxSwift for business logic 
  - connection  is handled via bluetooth
  - game server is based on state machine pattern
  
### Architecture

![](Resources/arch.png)

#### Onboarding:
When you lauch the game first time, onboarding screen with rules is appeared. It can be optionally launched in settings later.

![](Resources/welcome.png)

#### Home:
Gameplay playback is playing on the background. 

![](Resources/home.png)

#### Settings:
You can change your name shown to other players, ball colors and turn on onboarding screen with rules.

![](Resources/settings.PNG)

> Also supports dark theme

![](Resources/settings_dark.PNG)

#### Matching:
To start a game one player should select "Create game" (Central) and second "Find game" (Peripheral). The game server is running on (Central) player device.

![](Resources/matching.gif)

#### Gameplay: 

![](Resources/gameplay.gif)
![](Resources/gameplay_white.gif)

License
----

MIT
