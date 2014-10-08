[uRequire](http://urequire.org) [ResourceConverter](http://urequire.org/resourceconverters.coffee)

A uRequire ResourceConverter that executes a nodejs [`child_process.exec`](http://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback) CLI command against each matched `FileResource`s.

It returns the `stdout` of the execution, which becomes the `FileResource`'s `converted` property.

Its considered an *Abstract* or helper ResourceConverter:

a) By default `filez` is [], meaning no bundle source filenames are matched.

b) Also the `cmd` property (i.e the [`child_process.exec`](http://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback) `'command'` param) is undefined. The `'cmd'` RC property can be:

  * a `String`, which is prepended to the `srcFilename`. Eg if `cmd: 'ls -s'` the command to execute will be `ls -s 'someSrcFilename.ext'`.

  * a `Function(srcFilename, fileResource)`, returning the final command to execute (with `this` bound to RC instance).

The options object of [`child_process.exec`](http://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback) is naturally supported, having only `cwd` defaulting to `bundle: path`.

# Simple usage:

```
   resources: [
        ...
        [ 'exec', {
            $cmd: 'ls -s',
            $filez: ['only/these/files/**/*.*', '!not/these/**/*']
            env: { envkey: 'envvalue'} }]
        ...
   ]
```

Note that this will use the 'exec' RC its self - not very safe if for eg. you decide later on you need some other usage for exec along with this.
 You should instead use an extended / subclass of 'exec'.

# Subclassing `exec`

You can provide your own *exec-based* ResourceConverter (i.e extend 'exec', without hassling the original 'exec') like this:

```
    function(lookup) {
        return _.extend( lookup('exec').clone(), {
          name: 'lessc',
          filez: '**/*.less',
          cmd: 'lessc --compress',
          convFilename: '.css'
        });
    };
```

This new 'lessc' RC will convert all `*.less` files into `*.css` in the bundle, using the `exec` RC underneath (which will be left intact).
Note that this function can appear as-is in your `bundle.resources` or published as 'urequire-rc-lessc' and then referenced and further customized at resources.

If there is a `main.less` that imports all other `.less` files (as is usually the case), you simply also pass the `srcMain` RC property above or the users of `lessc` can reference & pass properties to the (perhaps `node_modules/urequire-rc-lessc` defined) RC like this:

```
    resources: [
        [ 'lessc', { $srcMain: 'style/main.less' }]
    ]
```

With a tiny bit of work, you could also pass all `lessc` CLI options like `--compress` (just turn `cmd` into a function that enumerates `this.options` and append them appropriately), see http://github.com/anodynos/urequire-rc-less/

# License

The MIT License

Copyright (c) 2014 Agelos Pikoulas (agelos.pikoulas@gmail.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
