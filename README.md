# GODOT Sprite Shader Mixer
Ok, here we are.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/YourUsername/YourRepository/LICENSE)
[![Godot](https://img.shields.io/badge/Godot-4.1.1%2B-blueviolet)](https://godotengine.org/)

Some examples of what this addon can do:

![supergodot5v2](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/b373fda9-38d8-4389-babb-ffe6e8d69cd1)

![supergodot](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/2171350c-8f08-41d3-99b3-10ddce6d41d9)

![supergodot2](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/c430fb4d-1375-442f-a1c9-65f3050e329f)

![supergodot3](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/ed1e3375-3396-4bb9-bc18-f3b28bfa80a9)

![supergodot4](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/4c76ed2c-ce48-490e-b0b5-28ca8d91e773)

![manager](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/4d43126e-37bf-463d-b7e7-508a6d296e0c)

Disclaimer: This project is inspired by [godot-sprite-shader](https://github.com/duongvituan/godot-sprite-shader) by duongvituan. Initially I've got and adapted a lot of shaders from there, and also from the great web page https://godotshaders.com/. I want to express my sincere gratitude for the inspiration them provided.

## Description

The Godot Sprite Shader Mixer is a plugin for Godot that allows Sprite2D and AnimationSprite2D (since version 1.2 also Label and ColorRect) nodes to blend shaders from a list of available shaders. Users can select and add shaders to sprites dynamically, automatically downloading them from GitHub as needed. The plugin handles shader generation and blending, resulting in a texture that combines all selected shaders.

## Features

- Dynamic blending of shaders on Sprite2D and AnimationSprite2D nodes (since 1.2 version also Label and ColorRect).
- Automatic shader downloading from GitHub.
- Generation and application of combined shaders.
- Customization of the intensity of each shader.
- Search Manager with preview

## Installation

To use this plugin, follow these steps:

1. Download the repository or clone it into your Godot project.
2. Enable the plugin in your project's settings.
3. Open the "Plugins" window in Godot and configure the options as needed.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/2a6bb11e-89e8-41b1-ad89-7a2a265df5f8)
 

## Usage

1. Add a Sprite2D or AnimationSprite2D (since version 1.2 also Label and ColorRect) node to your scene with a texture or animation.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/fd6e12b1-b83b-4bac-b35b-46a5177dfb1c) 

2. In the Inspector tab, you will find a new section called "Create Shader Mixer."

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/02d3c151-fbf9-4133-a201-24ecc173d29b)

3. Once done, the section will grow. The first time you need to download (or sync) the list of available shaders at this github page. Click on "Sync List".

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/6481ebfb-7e5c-43bc-b2e4-ff712f7f20d8)

4. Wait and you will get a list of available shaders. The list can grow over time when new shaders are available.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/936b2fc7-8c42-411c-8952-ade6abb2f4ba)

5. Select one shader. The first time you will need to download the shader, and textures if needed.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/f0d3a9db-3ef9-4cc3-abb9-a7c76eab4340)

6. Wait for the download and you will see the shader applied to the texture.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/2a5e68cc-8e49-419d-b931-0732c9425dee)

8. You can adjust all the parameters of the shader going directly to the shader params, at the material->shader inspector. It works like any shader, nothing special. The interesting part is that the plugin created that shader for you. But that's not all.

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/d01ac058-baea-4917-bb93-4ee762f4e8ec)

10. Go again and select a different shader, now you can mix them. The plugin will download, and create a new shader blending both shaders!

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/dec25c2b-7f7c-409b-ba6f-1b86a8b4c1f6)

12. By the way, you can see info about the shader if you press the "List of Current Shaders" button

![image](https://github.com/spheras/godot-sprite-shader-mixer/assets/3862933/dbd107cf-19e0-4caf-9507-7038bb90da09)

14. You can reorder the shaders, it affects the way they are mixed. You can quit a shader from your shader code. You can also remove the downloaded shader (you can download it again later). Be free and experiment with it!


15. The point is that the plugin creates a shader script for your texture with the shaders you select. The collection will grow, it is open to incorporate new shaders easily, just making a pull request over the shaders branch. So, consider sync the shader list to see if there are new shaders available. (explained later)

    
## Contribution

Contributions are more than welcome! This is a tool I need for my own game.
Yes, I come from Unity and I needed something like this :D.
The point is that it is difficult to maintain by only one person, so contributions are more than needed.
If you wish to improve this project, please:

1. Open an issue to discuss your ideas or problems.
2. Fork the repository, make your changes, and create a pull request.
3. Make sure to follow the contribution guidelines and code of conduct.

## HEY! I want to add a new Shader for this incredible tool!
Great! that's the idea, increase the collection of shaders.  One of the positive things about this plugin is that it doesn't have the shaders inside, it downloads them from this page when the user wants to apply the shader and mix with others. Therefore, we can grow with new shaders, without affecting them.

First of all, all the shaders are in a separate branch of this project:
https://github.com/spheras/godot-sprite-shader-mixer/tree/v1/shaders

I mean, if you only want to add a new shader, you only need to PR that branch.
The plugin will get shaders from this branch, syncing what shaders are available. There are three main aspects to consider:

1. The file shaders.json. This file contains the definition of all the available shaders. If you want to add a new one, you will need to add a new shader info there.
2. The shader (.gdshader) itself. The shader info JSON contains the filename of the shader, among other info. It must be unique as possible, to avoid conflicts with other shaders.
3. Textures. Some shader parameters need to put textures inside. The plugin sets those texture parameters with a texture image.



## License

This project is licensed under the [MIT License](LICENSE).

---

Thank you for your interest in Godot Sprite Shader Mixer! If you have any questions, suggestions, or issues, please feel free to contact me.
