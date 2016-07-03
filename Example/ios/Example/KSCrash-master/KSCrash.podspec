Pod::Spec.new do |s|
  IOS_DEPLOYMENT_TARGET = '6.0' unless defined? IOS_DEPLOYMENT_TARGET
  s.name         = "KSCrash"
  s.version      = "1.6.0"
  s.summary      = "The Ultimate iOS Crash Reporter"
  s.homepage     = "https://github.com/kstenerud/KSCrash"
  s.license     = { :type => 'KSCrash license agreement', :file => 'LICENSE' }
  s.author       = { "Karl Stenerud" => "kstenerud@gmail.com" }
  s.ios.deployment_target =  IOS_DEPLOYMENT_TARGET
  s.osx.deployment_target =  '10.8'
  s.tvos.deployment_target =  '9.0'
  s.source       = { :git => "https://github.com/kstenerud/KSCrash.git", :tag=>s.version.to_s }
  s.frameworks = 'Foundation'
  s.libraries = 'c++', 'z'
  s.xcconfig = { 'GCC_ENABLE_CPP_EXCEPTIONS' => 'YES' }
  s.default_subspecs = 'Installations'

  s.subspec 'no-arc' do |sp|
    sp.source_files = 'Source/KSCrash/Recording/**/KSZombie.{h,m}'
    sp.requires_arc = false
  end

  s.subspec 'Recording' do |recording|
    recording.dependency 'KSCrash/no-arc'
    recording.source_files   = 'Source/KSCrash/Recording/**/*.{h,m,mm,c,cpp}',
                               'Source/KSCrash/llvm/**/*.{h,m,mm,c,cpp}',
                               'Source/KSCrash/swift/**/*.{h,m,mm,c,cpp}',
                               'Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h'
    recording.exclude_files = 'Source/KSCrash/Recording/**/KSZombie.{h,m}'
    recording.public_header_files = 'Source/KSCrash/Recording/KSCrash.h',
                                    'Source/KSCrash/Recording/KSCrashC.h',
                                    'Source/KSCrash/Recording/KSCrashContext.h',
                                    'Source/KSCrash/Recording/KSCrashReportVersion.h',
                                    'Source/KSCrash/Recording/KSCrashReportWriter.h',
                                    'Source/KSCrash/Recording/KSCrashState.h',
                                    'Source/KSCrash/Recording/KSCrashType.h',
                                    'Source/KSCrash/Recording/Sentry/KSCrashSentry.h',
                                    'Source/KSCrash/Recording/Tools/KSArchSpecific.h',
                                    'Source/KSCrash/Recording/Tools/KSJSONCodecObjC.h',
                                    'Source/KSCrash/Recording/Tools/NSError+SimpleConstructor.h',
                                    'Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h',
                                    'Source/KSCrash/Recording/Tools/RFC3339DateTool.h'
  end

  # This subspec is just to optionally expose the advanced headers
  s.subspec 'RecordingAdvanced' do |advanced|
    advanced.dependency 'KSCrash/Recording'
    # Just add .h files; the .m files are all compiled in the Recording spec
    advanced.source_files = 'Source/KSCrash/Recording/KSCrashAdvanced.h',
                            'Source/KSCrash/Recording/KSCrashDoctor.h',
                            'Source/KSCrash/Recording/KSCrashReportFields.h',
                            'Source/KSCrash/Recording/KSCrashReportStore.h',
                            'Source/KSCrash/Recording/KSSystemInfo.h',
                            'Source/KSCrash/Recording/KSSystemInfoC.h'
  end

  # This subspec is just to optionally expose the tools headers
  s.subspec 'RecordingTools' do |tools|
    tools.dependency 'KSCrash/Recording'
    # Just add .h files; the .m files are all compiled in the Recording spec
    tools.source_files = 'Source/KSCrash/Recording/Tools/*.h'
    tools.exclude_files = 'Source/KSCrash/Recording/Tools/KSZombie.h'
  end

  s.subspec 'Reporting' do |reporting|
    reporting.dependency 'KSCrash/Recording'

    reporting.subspec 'Filters' do |filters|
      filters.subspec 'Base' do |base|
        base.source_files = 'Source/KSCrash/Reporting/Filters/Tools/**/*.{h,m,mm,c,cpp}',
                            'Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h',
                            'Source/KSCrash/Reporting/Filters/KSCrashReportFilter.m'
        base.public_header_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h'
      end

      filters.subspec 'Alert' do |alert|
        alert.dependency 'KSCrash/Reporting/Filters/Base'
        alert.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterAlert.h',
                             'Source/KSCrash/Reporting/Filters/KSCrashReportFilterAlert.m'
      end

      filters.subspec 'AppleFmt' do |applefmt|
        applefmt.dependency 'KSCrash/Reporting/Filters/Base'
        applefmt.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterAppleFmt.h',
                             'Source/KSCrash/Reporting/Filters/KSCrashReportFilterAppleFmt.m'
      end

      filters.subspec 'Basic' do |basic|
        basic.dependency 'KSCrash/Reporting/Filters/Base'
        basic.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterBasic.h',
                             'Source/KSCrash/Reporting/Filters/KSCrashReportFilterBasic.m'
      end

      filters.subspec 'Stringify' do |stringify|
        stringify.dependency 'KSCrash/Reporting/Filters/Base'
        stringify.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterStringify.h',
                                 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterStringify.m'
      end

      filters.subspec 'GZip' do |gzip|
        gzip.dependency 'KSCrash/Reporting/Filters/Base'
        gzip.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterGZip.h',
                            'Source/KSCrash/Reporting/Filters/KSCrashReportFilterGZip.m'
      end

      filters.subspec 'JSON' do |json|
        json.dependency 'KSCrash/Reporting/Filters/Base'
        json.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterJSON.h',
                            'Source/KSCrash/Reporting/Filters/KSCrashReportFilterJSON.m'
      end

      filters.subspec 'Sets' do |sets|
        sets.dependency 'KSCrash/Reporting/Filters/Base'
        sets.dependency 'KSCrash/Reporting/Filters/AppleFmt'
        sets.dependency 'KSCrash/Reporting/Filters/Basic'
        sets.dependency 'KSCrash/Reporting/Filters/Stringify'
        sets.dependency 'KSCrash/Reporting/Filters/GZip'
        sets.dependency 'KSCrash/Reporting/Filters/JSON'

        sets.source_files = 'Source/KSCrash/Reporting/Filters/KSCrashReportFilterSets.h',
                            'Source/KSCrash/Reporting/Filters/KSCrashReportFilterSets.m'
      end

      filters.subspec 'Tools' do |tools|
        tools.source_files = 'Source/KSCrash/Reporting/Filters/Tools/**/*.{h,m,mm,c,cpp}'
      end

    end

    reporting.subspec 'Tools' do |tools|
      tools.frameworks = 'SystemConfiguration'
      tools.source_files = 'Source/KSCrash/Reporting/Tools/**/*.{h,m,mm,c,cpp}'
    end

    reporting.subspec 'MessageUI' do |messageui|
    end

    reporting.subspec 'Sinks' do |sinks|
      sinks.ios.frameworks = 'MessageUI'
      sinks.dependency 'KSCrash/Reporting/Filters'
      sinks.dependency 'KSCrash/Reporting/Tools'
      sinks.source_files = 'Source/KSCrash/Reporting/Sinks/**/*.{h,m,mm,c,cpp}'
    end

  end

  s.subspec 'Installations' do |installations|
    installations.dependency 'KSCrash/Recording'
    installations.dependency 'KSCrash/Reporting'
    installations.source_files = 'Source/KSCrash/Installations/**/*.{h,m,mm,c,cpp}'
  end

end
