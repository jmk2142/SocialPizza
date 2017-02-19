# SocialPizza

This is just a demonstration app (messy) to test out some of the basic features of [Firebase](https://firebase.google.com) - namely the Database and Storage features.

Overall it's not so bad. I think I can narrow this demo down and clean it up into parts now that I understand the gist of the features and caveats.

## Demonstration
You can check out the demo on github pages at: https://jmk2142.github.io/SocialPizza.

**NOTE:** The demo is _a lot cooler_ if you have two different computers looking at the same page at the same time. This is a _real-time_ app.

## Installation
You need `bower` for this to work. See [Bower](https://bower.com) for details.

You can install bower on your system (globally) through `npm`.

```
npm install bower -g
```
Basically, `bower` is another package manager much like `npm` but for front-end libraries. That is, stuff like [bootstrap](https://getbootstrap.com), [jQuery](https://jquery.com), [fontawesome](https://fontawesome.com), etc.

Bower makes it easy to install these client-side libraries onto your local system. For example, instead of going to the jQuery page, finding the CDN url, copy pasting that into the HTML as `<script>`, we can simply do:
```
bower install jquery --save
```
Bower will download and throw your dependencies like jQuery into the `bower_components` folder.

The `--save` option writes to the `bower.json` file under _dependencies_. This allows anyone who downloads this package to easily install all dependencies with one command.

For example, to install the two dependencies of this project, `lodash` and `font-awesome`, simply install the `bower` packages by typing into this project directory:
```
bower install
```

**Project won't run without those dependencies.**
