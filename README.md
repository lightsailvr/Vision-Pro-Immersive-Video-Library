# Vision Pro Immersive Video Library

*A bare-bones video library application for your Immersive Videos on Apple Vision Pro*

As an immersive video creator, I was frustrated by the lack of apps at launch to playback immersive video. The headset didn’t ship with any way to play spherical video. I found applications like RealityPlayer and MoonPlayer on the App store to be buggy, lacking proper unwrapping, and low quality.

Thanks to the efforts of many in the community, code examples began to emerge that solved this issue. A huge thank you to [Mike Swanson](https://blog.mikeswanson.com) for contributing his open source code which helped me figure out how to decode the MV-HEVC streams and create the appropriate geometry for high quality playback. The immersive video community would be lost without his efforts!

I’ve taken what he has built and created a library front end around it so that creators like myself can host our videos and have a high quality way to play them back and share them with folks who would like to view content on Vision Pro.

![Application Interface](https://www.lightsailvr.com/images/repo_readme_images/main-interface.png)

## How it works

Upon first launching the application, users will be presented with the standard Document Picker, which is expecting the input of a JSON file. This is very easy to put together in any text edtior, as long as it is saved with the extension “.json”. Here is an example of the syntax:

```json
[
    {
        "id": 0,
        "url" : "https://link-to-your-content/mv-hevc-video.mp4",
        "title": "Introduction to VR 180",
        "client": "Canon",
        "description": "Put on your VR headset and let director Matthew Celia guide you on an immersive introduction to stereoscopic 3D 180° VR filmmaking. As the Creative Director of Light Sail VR, Celia has made many immersive films using a variety of equipment, but nothing has him more excited than Canon’s revolutionary VR lens: the RF5.2mm F2.8 L Dual Fisheye Lens for the EOS VR System.",
        "poster": "https://link-to-your-poster/image.png",
        "thumbnail": "https://link-to-your-thumbnail/image.png",
        "category": "Commercial",
    },
    {... etc}
]
```

**ID:** This is a unique number for each entry, starting at 0

**URL:** This URL corresponds to where your video is hosted. I typically host mine on AWS, but any public web link will work. The app will download video from this address and place a local copy into the sandboxed documents folder. Upon loading the library, the app checks to see if the videos are in this directory. If they are, no option to download will be presented.

**Title:** The title of your video. This appears in the poster interface as well as the in the Details Ornament.

**Client:** Since we do a lot of commercial work, having the client is important, but you could fill this in with whatever you wish. This is presented in the poster view underneath the title.

**Description:** A description of the video which is presented in the Details Ornament

**Poster:** This URL is the poster that is shown in the library. Posters should be 238x334 or a variation of size in that aspect ratio.

**Thumbnail:** This is the thumbnail presented in the Details Ornament. The size is 200x160 with a 20px rounded corner.

**Category:** This is the category shown on the poster. Right now, the application only supports a single category. Again you could use this for anything you wish.

To get the JSON onto my Apple Vision Pro, I typically AirDrop it to myself from my Mac and save it into my Documents. When you select the JSON in the application, it will copy it into a Library folder inside the Application folder. When launching the application again, it will automatically select the first file in that folder (by name) and load that as the default library. Alternative libraries can be selected by using the navigation back chevron in the library view to navigate back to the document picker. This way, users can set up a default library of their content and when sharing the headset in Guest Mode, guests don’t have to go through the friction of picking a Library.

## Video Playback

Right now, I have only really tested 180 stereoscopic video encoded using the spatial command line tool that Mike Swanson has developed. It seems to work well!

If you tap your fingers while playing, a menu pops up that details the video metadata and provides a buttons to pause/resume the video, restart the video, or exit the immersive view and return to the library.

## Screenshots

![Poster View](https://www.lightsailvr.com/images/repo_readme_images/poster.png)

Poster View

![Details View presented as an ornament](https://www.lightsailvr.com/images/repo_readme_images/details.png)

Details View presented as an ornament

![Player Controls View available when tapping fingers in the Immersive View](https://www.lightsailvr.com/images/repo_readme_images/immersive.png)

Player Controls View available when tapping fingers in the Immersive View

## Usage
Clone the repo and open the project in Xcode 15.2 (or later). Then run it in the Simulator or on a device. Be sure to have a valid JSON file and all your assets sorted out!

## Closing Thoughts

I hope this is useful to the community. I have only been programming in Swift for two weeks so I highly encourage much more advanced Swift developers to pull the code and make improvements and suggestions so the immersive video community can have a tool to showcase content on the Apple Vision Pro!
