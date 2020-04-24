
Getting Started
This app is the result of Poq – iOS Developer Challenge.
Architecture - MVP (the style similar to SurfMVP).
The only singleton in the project is ModulesFactory, all other objects are injected. No DI framework used. Each service is injected into presenter in modules factory when presenter is created. Services inject beetween themself in ServiceFactory file. 
Used Alamofire for networking. Each request is adopting APIRequestProtocol | response - APIResponseProtocol. 
All assets, colors and strings are stored in /Generated folder, created by SwiftGen.

Dark mode included. 

Testing
There are few dummy-tests for response and mapping.

3rd party frameworks
Alamofire, SDWebImage, SwiftLint, SwiftGen, NVActivityIndicatorView 

Author
Vitalii Pryidun
