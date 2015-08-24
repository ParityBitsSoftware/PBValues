Pod::Spec.new do |spec|
  spec.name         = 'PBValues'
  spec.version      = '0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/ParityBitsSoftware/PBValues'
  spec.authors      = { 'Andrew Tillman' => 'andrew.g.tillman+pbvalues@gmail.com' }
  spec.summary      = 'Useful swift value structs for iOS and OS X.'
  spec.source       = { :git => 'https://github.com/ParityBitsSoftware/PBValues', :tag => '0.1' }
  spec.framework    = 'PBValues'
end