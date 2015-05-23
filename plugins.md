# Plugins

As of version 0.3, lua-repl supports a plugin mechanism.  For an example, please download the source code for
lua-repl and look at `repl/plugins/example.lua`.

# Available Plugins

lua-repl 0.3 ships with several plugins.  If you use the example script `rep.lua`, some of them are loaded automatically;
these are marked with an asterisk.

## autoreturn (\*)

Automatically returns the the results of the evaluated expression.  So instead of having to type 'return 3', you may
simply type '3'.

## completion (\*)

Provides completion facilities via the 'completion' feature.  Other plugins may hook into this to provide tab completion.

## example

Simply an example plugin.

## history (\*)

Provides history facilities (and the 'history' feature), storing each line entered as an individual history entry,
and persisting the history in `$HOME/.rep.lua.history`.  Other plugins may hook into this.

## keep\_last\_eval

Retains the results of the previously evaluated expression in global variables.  The first result is stored in `_1`, the
second in `_2`, etc.  For brevity's sake, the first result is also stored in `_`.

## linenoise (\*)

Hooks into the linenoise library.  Allows the use of tab completion and history.

## pretty\_print

'Pretty prints' return values.  Tables are printed in expanded form.  Colors are provided if lua-term is installed.

## rcfile (\*)

Loads Lua code in `$HOME/.rep.lua` if the file exists.  The repl object is provided to the file in a variable named `repl`, so
users may load plugins of their choosing.

## semicolon_suppress_output

Suppresses automatic printing of an expression's result if the expression ends in a semicolon.

# Creating a Plugin

If you would like to create your own plugin, it must be in a file under `repl/plugins/` in your `package.path`.

# Plugin Objects

When a plugin is loaded, it is provided with five special objects that are used to affect the behavior of the REPL
object loading the plugin.

## repl

The `repl` object is a proxy object for the REPL object loading the plugin; you can invoke methods on it, create methods on
it, set properties on it, etc.  However, if you try to create a method on the `repl` object that already exists, an error
will occur.  This is to keep plugin authors from stepping on each others' toes.

## before

The `before` object is another proxy object from the plugin environment.  If you add methods to the `before` object, the original
method remains intact; however, the method you added will be called before the original.  For example, if you wanted to print
"I got some results!" before you display them on the command line, your plugin could do this:

```lua
function before:displayresults(results)
  print 'I got some results!'
end
```

This is called *advice*, and is stolen from Moose, an object system for the Perl programming language.

When you apply multiple pieces of advice via `before`, they are called in last-in-first-out order:

```lua
function before:method()
 print 'Second!'
end

function before:method()
 print 'First!'
end
```

`before` also receives all of the parameters to the original method.  If they are tables, userdata, etc, you may alter them,
which can alter the behavior of the original method, for better or for worse.

If the method you are applying advice to does not exist on the current REPL object, an error will occur.  This way, developers
can find out about API changes quickly, albeit noisily.

## after

The `after` object is another proxy object that attaches advice to the loading REPL object.  As you can likely tell from its name,
advice applied via the `after` object occurs after the original method.  Advice applied via after is called in first-in-first-out order:

```lua
function after:method()
 print 'First!'
end

function after:method()
 print 'Second!'
end
```

Like `before`, if you try applying advice to a method that doesn't exist, an error will occur.  Also like `before`, after advice receives
all of the parameters passed to the original method.

## around

The `around` object is another advice object, but it works a little differently than `before` or `after`.  `around` replaces the current
method will the advice, and like `before` and `after`, receives all of the parameters that would be passed to the original.  However,
`around` also receives an additional parameter immediately before the parameters: the original method.  This way, you can invoke
the method's original functionality if needed.  For example:

```lua
function around:displayresults(orig, results)
  print "I'm displaying some results!"
  orig(self, results) -- don't forget self!
  print "Now I'm done!"
end
```

Like the other advice objects, you can't apply advice to a method that doesn't exist.  Also, be warned: the `around` advice does nothing
to make sure that the parameters are passed to the original function, and it doesn't make sure that the return values from the original
function are returned.  You need to do that yourself.

## override

The `override` object isn't really an advice object; adding methods to it will replace the methods in the REPL object itself.  However,
it will fail if that method does not already exist.  The rule of thumb is if you want to add new methods to the REPL object, use
`repl`; if you want to completely override an existing method, use `override`.  Keep in mind this will blow away all advice applied to
a method from other plugins; use with caution!

# Features

Sometimes, different plugins will want to provide a method, but implemented in a different way.  For example, the completion plugin
included with lua-repl implements a tab completion method; however, if you are embedding lua-repl into your own environment, you may
have a more sophisicated way to provide completions.  Other plugins (like the linenoise plugin) may want to hook into the completion
feature itself, without being tied to a particular implementation.  So plugins may advertise a list of *features* that they provide,
so that they can develop loose relationships between one another.  To advertise features for your plugin, simply set the features variable:

```lua
features = 'completion' -- make sure you're not setting a local!
```

If you wish you provide multiple features, simply use a table:

```lua
features = { 'completion', 'something_else' }
```

Obviously, plugins providing a feature need to agree on a standard interface of methods that they provide.  No framework is in place for this as
of yet.

REPL objects may provide features as well; for example, `repl.console` provides the 'console' feature.  You can use this to make sure your
plugins are only loaded in certain environments.

# REPL Methods

Now that you know how to affect the behavior of lua-repl with plugins, let's go over the methods you may advise/override, or call yourself from
within your advised/overridden methods.  Please keep in mind that since lua-repl is still a young project, this API is subject to change.

## repl:getprompt(level)

Returns the prompt string displayed for the given prompt level, which is either 1 or 2.
1 signifies that the REPL is not in a multi-line expression (like a for loop); 2 signifies
otherwise.

## repl:prompt(level)

Actually displays the prompt for the given level.  You more likely want to deal with
getprompt or showprompt.

## repl:name()

Returns the name of the REPL, used when compiling the chunks for evaluation.

## repl:traceback(err)

Returns a stack trace, prefixed by the given error message.

## repl:detectcontinue(err)

Detects whether or not the given error message means that more input is needed for a complete
chunk.  You probably shouldn't touch this.

## repl:compilechunk(code)

Compiles the given chunk of code, returning a function, or a falsy value and an error message.

## repl:getcontext()

Returns the function environment that the REPL evaluates code in.

## repl:handleline(line)

Handles a line of input, returning the prompt level (1 or 2).  Note that if this method is
called, an evaluation does not necessarily occur.

## repl:showprompt(prompt)

Displays the given prompt.

## repl:displayresults(results)

Displays the results from an evaluation.  `results` is a table with the individual values in
the integer indices of the table, with the `n` key containing the number of values in the table.

## repl:displayerror(err)

Displays an error from an evaluation.

## repl:hasplugin(plugin)

Returns `true` if the given plugin has been loaded, `false` otherwise.

## repl:hasfeature(feature)

Returns `true` if the given feature has been loaded, `false` otherwise.

## repl:requirefeature(feature)

If the given feature has been loaded, do nothing.  Otherwise, raise an error.

## repl:ifplugin(plugin, action)

If the given plugin has been loaded, call `action`.  Otherwise, if the plugin
is ever loaded in the future, call `action` after that loading occurs.

## repl:iffeature(feature, action)

If the given feature has been loaded, call `action`.  Otherwise, if the feature
is ever loaded in the future, call `action` after that loading occurs.

## repl:loadplugin(plugin)

Loads the given plugin.  If the plugin returns a value, that value is returned.

## repl:shutdown()

Called when the REPL is exited.  Don't call this yourself!

## repl:lines() -- repl.sync only

Returns an iterator that yields a line of input per invocation.

# The Future

This is the first release of lua-repl with plugins.  The future will bring various
refinements to the plugin interface, along with the following planned features:

## Feature Interfaces

Earlier I mentioned that features have a sort of "gentlemen's aggreement" on what
methods they will provide.  It would be nice if the plugin system had a way of
enforcing that.

## Attribute Storage

Currently, if a plugin wants to store some information between method calls, it needs
to store it on the REPL object (`self`) and hope no other plugins (or REPL clone) will
use the same name.  Plugin-specific storage is a high priority.

## Configuration

Currently, plugins don't have any sort of configuration mechanism.  I plan to change that.

## Library Plugins

Some plugins may want to leverage functionality of others without loading those others into
the REPL itself.  I call these *library plugins*.

## Better Diagnostics

If you try to add a method that has already been added, or provide a feature that has already been
provided, you receive no information on which plugin provided the method or feature in question.
It would be nice to know.
