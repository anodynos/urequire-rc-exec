nodefn = require "when/node/function"
_ = require 'lodash'

execP = nodefn.lift require("child_process").exec

module.exports = [
  '@~exec' # a FileResource -not reading source- & filez matching `srcFilename`s

  'Executes a `child_process.exec` CLI command against each matched FileResource, returning stdout.'

  [] # no filez are matched by this `abstract` RC

  (f)-> # run asynchronously, returning an A+ promise
    command =
      if _.isString @cmd
        "#{@cmd} '#{f.srcFilename}'"
      else
        if _.isFunction @cmd
          @cmd f.srcFilename, f
        else
          throw """
              Error in 'urequire-rc-exec' derived ResourceConverter named '#{@name}'
              `cmd` must be a String or Function. `cmd` = \u001b[0m#{
                (require 'util').inspect @cmd, {showHidden:false, depth:null, colors:true} }
            """
    @options.cwd or= f.bundle.path
    execP(command, @options).then (res)-> res[0] # yield stdout from promise (`exec` returns [stdout, stderr])
]
