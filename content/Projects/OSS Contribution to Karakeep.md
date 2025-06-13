A few days ago (8th June), [release 0.25.0 of Karakeep](https://github.com/karakeep-app/karakeep/discussions/1561) was published. It included a feature contribution I wrote to implement reader mode for the cross-platform mobile app! This is my first time doing this for a popular open source software (OSS) project.

# What is Karakeep?

> Karakeep (previously Hoarder) is a self-hostable bookmark-everything app with a touch of AI for the data hoarders out there.

Karakeep has a server/web app that is orchestrated using Docker, as well as an Android and iOS app.

## Server set up

I was able to self-host a Karakeep instance on an absolutely *tiny* cloud VM with one CPU core and only 1 GB of RAM. I've added the main config to the bottom of this page in case you want to start experimenting yourself with a [[OSS Contribution to Karakeep#Lightweight deploy config]].

# My contribution

I discovered Karakeep when I learned that [Pocket](https://getpocket.com) was shutting down on its app on the 8th of July (export and API functionally to follow on 8th October). In [their announcement](https://support.mozilla.org/en-US/kb/future-of-pocket), Mozilla (mainly known for their Firefox browser) they don't explain very much of their rationale, simply saying not much more than that:

> ...the way people use the web has evolved, so we’re channeling our resources into projects that better match their browsing habits and online needs.

I have been an almost daily free tier user of Pocket for a number of years, particularly the Android app. One of the best things about the app is that I can save an article without visiting the webpage and then open it in the reader mode in the app (when supported, about 70% of websites do). This is a better reading experience by far and it has been useful when researching topics too, to set tags and so on.

So, I tried Karakeep and found it to be great. I exported my bookmarks from Pocket and discovered there was even support to import from the Pocket export format. I had some trouble initially, due to the low resources of my VM (see below for how I solved it) but eventually I was able to import everything.

When I got set up with the Karakeep web app and then tried the mobile app, I noticed that it didn't have a reader mode and used an embedded web view instead. So, because it was open source, I decided to implement it! 🚀 I looked through the issues on the [Karakeep GitHub repo](https://github.com/karakeep-app/karakeep/issues) and found some that mention it. I then asked the originator and maintainer of the app [Mohamed Bassem](https://github.com/MohamedBassem) about it, who was supportive of the contribution (who I humbly thank), and so I prepared the feature for submission.

The mobile app is written in React Native, which I have experience with so I decided to try [[Coding with AI#Vibe coding]] a first draft with [[Coding with AI]] tool Claude Code since I'd be able to assess how good it actually is. I'd been messing around with this recently and found it surprisingly good, at Python scripts anyway.

It was far simpler than I thought to implement (and only a few hundred lines), owing a lot to the good practices already in the codebase, and the only small wrinkle was supporting dark mode. The AI tool wasn't able to get me beyond a first draft, which makes sense in a relatively mature codebase, and I'm not sure if it was actually faster or better to be honest. In the end, I took the code and completed it myself, and of course reviewed it for correctness and tested.

In [the PR](https://github.com/karakeep-app/karakeep/pull/1509), Bassem himself contributed to the feature to support non-link bookmark types and it was included in the release. I now have the change I wanted on my phone and I'm back to using it every day for articles. This is one of the reasons why open source is brilliant! You can go from discovery of an open source app that is _almost_ what you want, and then contribute something to develop it further for the benefit of all—including you, if you would like.

# Lightweight deploy config

I needed to disable the screenshot functionality and the ad blocker. Both use significant resources in the headless Chromium service that runs alongside the web app and Meilisearch services.

I set these flags (along with the other usuals, see [the docs](https://docs.karakeep.app/Installation/docker#3-populate-the-environment-variables)), in `.env`:

```
CRAWLER_STORE_SCREENSHOT=false
CRAWLER_ENABLE_ADBLOCKER=false
```

I also needed to add some memory limits (`mem_limit`) and set explicitly to use swap space (`memswap_limit`), since the RAM is so low.

The full `docker-compose.yml` with my customizations:

```
services:
  web:
    image: ghcr.io/karakeep-app/karakeep:${KARAKEEP_VERSION:-release}
    restart: unless-stopped
    mem_limit: 800m
    memswap_limit: 2g
    stop_signal: SIGINT
    stop_grace_period: 30s
    volumes:
      - data:/data
    ports:
      - 3000:3000
    env_file:
      - .env
    environment:
      NODE_OPTIONS: --max-old-space-size=768
      MEILI_ADDR: http://meilisearch:7700
      BROWSER_WEB_URL: http://chrome:9222
      DATA_DIR: /data # DON'T CHANGE THIS

  chrome:
    image: gcr.io/zenika-hub/alpine-chrome:123
    restart: unless-stopped
    mem_limit: 300m
    memswap_limit: 600m
    command:
      - --no-sandbox
      - --disable-gpu
      - --disable-dev-shm-usage
      - --remote-debugging-address=0.0.0.0
      - --remote-debugging-port=9222
      - --hide-scrollbars
      - --headless=new
      - --single-process
      - --blink-settings=imagesEnabled=false
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:9222/json/version"]
      interval: 10s
      timeout: 3s
      retries: 3

  meilisearch:
    image: getmeili/meilisearch:v1.13.3
    restart: unless-stopped
    mem_limit: 400m
    memswap_limit: 800m
    env_file:
      - .env
    environment:
      MEILI_NO_ANALYTICS: "true"
    volumes:
      - meilisearch:/meili_data

volumes:
  meilisearch:
  data:
```