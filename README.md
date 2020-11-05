# reactive_rgb_v1
simple reactive RGB led, using the minim arduino lib

In order for this project to work, you need to install the **minim lib**.
Also you need to use **stereo mix** to listen to your output (https://www.youtube.com/watch?v=Cm8zNeHtXeo), so minim can use the signal as seen in this line:
```javascript
in = minim.getLineIn(Minim.STEREO);
```

Here you can see this project fully working:
https://www.youtube.com/watch?v=buRt3igY0UE
