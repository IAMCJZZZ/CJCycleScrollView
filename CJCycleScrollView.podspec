Pod::Spec.new do |s|

  s.name         = "CJCycleScrollView"
  s.version      = "0.1.4"
  s.summary      = "CJCycleScrollView.CJ"
  s.description  = <<-DESC
"CJCycleScrollView是一个可以自定义内容且不复用的轮播图"
                   DESC
  s.homepage     = "https://github.com/CJProgrammer/CJCycleScrollView"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "CJProgrammer" => "727459774@qq.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/CJProgrammer/CJCycleScrollView.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "CJCycleView/Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.requires_arc = true

end
