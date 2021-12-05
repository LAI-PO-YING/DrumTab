<h1 align="center"> DongZ DaZ </h1> <br>
<p align="center">
  <a href="https://github.com/LAI-PO-YING/DrumTab">
    <img alt="DongZ DaZ" title="DongZ DaZ" src="https://i.imgur.com/yfOXsPJ.png" width="450">
  </a>
</p>

<p align="center">
  Record your beats easily with DongZ DaZ.
</p>

<p align="center">
  <a href="https://apps.apple.com/tw/app/dongz-daz/id1591742250">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>
</p>

## Table of Contents

- [Introduction](#introduction)
- [Technique](#technique)
- [Features](#features)
- [Feedback](#feedback)

## Introduction

A new way to record and share your beats. With DongZ DaZ, user can easily sign in with Apple account and create their own rhythm by anywhere and anytime.

**Available on iOS only.**

<p align="center">
  <img src = "https://i.imgur.com/R4jXIyX.png" width=350>
</p>

## Technique

* Use AudioToolBox framework to precisely control the sounds in millisecond
* Use a well-designed data structure to save user’s creation with Firebase
* Customize music sheets view with accurate calculation
* Design cache mechanism to optimize the data usage and reduce server effort
* Make good use of GCD control and Lottie animation to improve user experience
* Use AVKit to control opeing video to make a gorgeous enter page

<p align="center">
  <img src = "https://i.imgur.com/SA0HLy7.jpg" width=700>
</p>

<p align="center">
  <img src = "https://i.imgur.com/Ja2MkZa.png" width=700>
</p>

## Features

A few things you can do with DongZ DaZ: 
#### - Browse creations
You can easily browse every creation in DongZ DaZ. Each post in Social-Page will be attached a creation. By clicking posts, you will enter next page to show the content of creation. You can watch and listen the creation or left message to creator. Also, if you really like the creation, you can easily add into your collection by clicking the collection button at the top-right corner.

![](https://i.imgur.com/mcFQCtv.gif)

#### - Record your beats
You can create your own beats in the second tab which is Creation-Page. In this page, you can edit all the drafts that you saved before. Or you can create a new one by click the plus button at the top-right corner. 
When clicking a draft or the plus button, you will be led to the next page which is the most important part of DongZ DaZ -- Record Page.

In Record Page, you can easily find that the page is divided into two part. 

At the bottom-half, we provide a new way to record your beats. Here we provide all of components of drum. There are Hi-Hat, Snare, High-Tom, Mid-Tom, Floor-Tom, Bass, Crash and Ride from the top to the buttom. 

At the top-half, we can convert your record to music sheet immediately. 

In current version, we support 4/4 beats and support up to 16th note as the smallest note. Each component we provide 16 grids to record. 16 grids stand for 1 section which means 4 grids stand for 1 beat.

![](https://i.imgur.com/K1ydgGR.gif)

Once you finish editing a section, you can press the plus button to create a new section. Since the rhythms in the creation are usually the same. The system will copy your latest section and bring it to the next section. If there isn't anything change, you can press the plus button agains to go on next section. 
Also, you can adjust BPM to change speeds or press the play button to check the current creation. The music sheet half top will be auto scrolled with your beats.

![](https://i.imgur.com/GNmwcKI.gif)

And once you finish all of your creation, you can press save to save your creation to the server or press publish to publish your creation to Social-Page to share your creation to all users in DongZ DaZ. 

![](https://i.imgur.com/p1BSQ0l.gif)

#### - Collect your favorite beats

In the third tab, we provide a space to let you collect your favorite creations by clicking the collection button. System will add the creation into your Collection-Page. You can easily find and browse the creation in your Collection-Page by tapping on it.

![](https://i.imgur.com/7NZ0H2D.gif)

Also, we provide searching function in this page. So you can easily find the creation you want by typing the creation name in the search bar.

![](https://i.imgur.com/BUDBDjR.gif)

#### - View your creation status

In the last tab, Profile-Page, you can view your status including how many creation you have created, how many followers you have and how many likes for you have earned. Also, we provide a ranking table to show top 3 creator in the server.

By clicking the setting button at the top right corner, you can view our privacy policy, log out or delete account.

![](https://i.imgur.com/ZfuOqyX.gif)



## Feedback

Feel free to send us feedback on [Medium](https://ivan-lai.medium.com) or [file an issue](https://github.com/LAI-PO-YING/drumTab/issues/new). Feature requests are always welcome.


