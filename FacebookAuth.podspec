Pod::Spec.new do |spec|
  spec.name = 'FacebookAuth'
  spec.version = '0.1.0'
  spec.authors = {'Moritz Lang' => 'moritz@slashkeys.com'}
  spec.homepage = 'https://github.com/slashkeys/FacebookAuth'
  spec.summary = 'Swift iOS Facebook login'
  spec.description = 'Nothing but Facebook login, entirely written in Swift.'
  spec.source = {:git => 'https://github.com/slashkeys/FacebookAuth.git', :tag => "v#{spec.version}"}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.ios.deployment_target = '9.3'

  spec.source_files = 'FacebookAuth/**/*.{swift}'
end
