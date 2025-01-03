Pod::Spec.new do |s|

    s.name                  = 'Shakuro.CommonTypes'
    s.version               = '1.9.5'
    s.summary               = 'Common Types'
    s.homepage              = 'https://github.com/shakurocom/CommonTypes'
    s.license               = { :type => "MIT", :file => "LICENSE.md" }
    s.authors               = {'apopov1988' => 'apopov@shakuro.com', 'wwwpix' => 'spopov@shakuro.com'}
    s.source                = { :git => 'https://github.com/shakurocom/CommonTypes.git', :tag => s.version }
    s.swift_versions        = ['5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9']
    s.source_files          = 'Source/*'
    s.ios.deployment_target = '15.0'

    #s.dependency 'CommonCryptoModule', '1.0.2'

end
