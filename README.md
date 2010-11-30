### Rails template generator for jquery, mysql, mongoid, sqlite and rspec

To use these generator copy this in your .bash_profile
<code>
  function railsapp {
    appname=$1
    shift 2
    rails new $appname -m https://github.com/brunowernimont/rails-templates/raw/master/app.rb -TJ $@
  }
</code>

So you can use this command in your shell instead of **rails new**
<code>
  railsapp app_name  
</code>

Bash function from https://github.com/ryanb/rails-templates/