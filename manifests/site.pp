require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

   #distributedlife
  include dropbox
  include java
  include android::sdk
  include android::tools
  include android::platform_tools
  include vlc
  include chrome
  include firefox
  include iterm2::stable
  include adium

  include osx::global::enable_standard_function_keys
  include osx::global::expand_save_dialog
  include osx::dock::autohide
  include osx::dock::clear_dock
  include osx::finder::empty_trash_securely
  include osx::finder::show_hidden_files
  include osx::finder::unhide_library
  include osx::finder::show_all_filename_extensions
  include osx::finder::show_warning_before_emptying_trash
  include osx::safari::enable_developer_mode
  include osx::disable_app_quarantine 
  include osx::software_update

  class { 'osx::dock::position':
    position => 'left'
  }

  class { 'osx::dock::hot_corners':
    top_right => "Start Screen Saver"
  }

  class { 'osx::sound::interface_sound_effects':
    enable => false
  }

  include zsh
  include opera
  include opera::mobile
  include wget
  include tilemill
  include heroku
  include evernote
  include xbox_360_controller
  include imagemagick
  include steam
  include sublime_text_2
  sublime_text_2::package { 'Better Javascript': 
    source => 'int3h/sublime-better-javascript'
  }
  sublime_text_2::package { 'CoffeeScript': 
    source => 'Xavura/CoffeeScript-Sublime-Plugin'
  }
  sublime_text_2::package { 'EditorConfig': 
    source => 'sindresorhus/editorconfig-sublime'
  }
  sublime_text_2::package { 'GitGutter': 
    source => 'jisaacks/GitGutter'
  }
  sublime_text_2::package { 'Github Color Theme': 
    source => 'AlexanderEkdahl/github-sublime-theme'
  }
  sublime_text_2::package { 'Github Flavored Markdown Preview': 
    source => 'dotcypress/GitHubMarkdownPreview'
  }
  sublime_text_2::package { 'GL Shader Validator': 
    source => 'WebGLTools/GL-Shader-Validator'
  }
  sublime_text_2::package { 'Jade': 
    source => 'davidrios/jade-tmbundle'
  }
  sublime_text_2::package { 'JSHint Gutter': 
    source => 'victorporof/Sublime-JSHint'
  }
  sublime_text_2::package { 'Markdown Extended': 
    source => 'jonschlinkert/sublime-markdown-extended'
  }
  sublime_text_2::package { 'OpenGL Shading Language (GLSL)': 
    source => 'euler0/sublime-glsl'
  }
  sublime_text_2::package { 'SCSS': 
    source => 'MarioRicalde/SCSS.tmbundle'
  }
  sublime_text_2::package { 'TrailingSpaces': 
    source => 'SublimeText/TrailingSpaces'
  }

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  nodejs::version { 'v0.6': }
  nodejs::version { 'v0.8': }
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
