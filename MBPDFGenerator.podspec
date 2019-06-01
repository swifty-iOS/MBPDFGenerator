Pod::Spec.new do |s|
    s.name = 'MBPDFGenerator'
    s.version = '1.0'
    s.summary = 'This generates PDF from UIViewController using native code.'
    s.homepage = 'https://github.com/swifty-iOS/MBPDFGenerator'
    s.license = 'MIT'
    s.author = { 'Swifty-iOS' => 'manishej004@gmail.com' }
    s.ios.deployment_target = '10.0'
    s.source= { :git => 'https://github.com/swifty-iOS/MBPDFGenerator.git', :tag => s.version }
    s.source_files = 'Source/*.swift'
    s.swift_version = '5.0'
end