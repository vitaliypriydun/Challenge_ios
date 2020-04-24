
Getting Started
This app is the result of iOS Developer Challenge.

Please note: 
Due to lack of experience with media player and audio recording - I guess there are best practices which I don't know about, so my code may not look polished. Hopefully I'll investigate more and find some best practices for that 
Things I didn't achieve: 
1) resuming playing when interacting with other players 
2) covering all alternative cases and edge-cases 
3) testing. have no experience with testing avfoundation related code

About app: 
Architecture - MVP (the style similar to SurfMVP).
The only singleton in the project is ModulesFactory, all other objects are injected. No DI framework used. Each service is injected into presenter in modules factory when presenter is created. Services inject beetween themself in ServiceFactory file. 
All assets, colors and strings are stored in /Generated folder, created by SwiftGen.

Dark mode included. 

3rd party frameworks - SwiftLint, SwiftGen 

Author
Vitalii Pryidun

P.S. don't be scared of "42" number, it's just movie reference, not the quantity of my tries :)
