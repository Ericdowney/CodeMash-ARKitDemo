# CodeMash 2019 - The Reality War

## ARDemo App

---

This app demonstrates features within the latest ARKit framework provided by Apple.  The purpose of this app is to illustrate how to interact with ARKit and the basic concepts of Augmented Reality.  To this end, there are no complicated 2D / 3D scenes.  In iOS the 2D / 3D rendering engines SpriteKit and SceneKit, respectively, handle all of the complicated drawing and rendering.  When interacting with ARKit, the rendering of 2D / 3D assets is the most complicated part.  Everything dealing with ARKit is relatively simple.  I have tried my best to isolate the code specific to augmented reality and rendering 2D / 3D assets to show the separation.  

---

## ARKit Features

In this section we'll go through a list of the features available in ARKit showing code snippets.

### Feature Point Tracking

This is the most basic feature of ARKit and is what drives most augmented reality interactions.  The code in the `FeaturePointTrackingViewController` will not show this because of how I've setup the inheritance within the app.  The code that configures augmented reality and feature point tracking is held within the `BaseARDemoViewController` in the `configureAR()` function.

