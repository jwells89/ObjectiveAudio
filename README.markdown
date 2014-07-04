#ObjectiveAudio
##About
**ObjectiveAudio** is based on the stunningly powerful [SFBAudioEngine](https://github.com/sbooth/SFBAudioEngine) and aims to provide two things:

1. A pure Objective-C wrapper for the wide array of functionality offered by SFBAudioEngine 
2. Genericized, ready-made components to reduce boilerplate and make audio playback, queueing, metadata editing, and more drop-dead simple and Cocoa-friendly

Currently, only OS X 10.8 and above is supported. iOS support should be simple to implement.

##Usage
1. Add `SFBAudioEngine.framework` to your project
2. Add `ObjectiveAudio.xcodeproj` as a subproject
3. Ensure that `ObjectiveAudio.framework` along with `SFBAudioEngine.framework` are linked and copied

##License
ObjectiveAudio is licensed under [BSDv3](http://opensource.org/licenses/BSD-3-Clause). Contributions are welcome; simply fork, make your changes, and file a pull request.