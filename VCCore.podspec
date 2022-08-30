Pod::Spec.new do |s|
    s.name= 'VCCore'
    s.version= '0.0.1-beta'
    s.license= 'MIT'
    s.summary= 'An SDK to manage your Decentralized Identities and Verifiable Credentials.'
    s.homepage= 'https://github.com/microsoft/VerifiableCredential-SDK-iOS'
    s.authors= {
      'symorton' => 'symorton@microsoft.com'
    }
    s.documentation_url= 'https://github.com/microsoft/VerifiableCredential-SDK-iOS'
    s.source= {
      :git => 'https://github.com/microsoft/VerifiableCredential-SDK-iOS.git',
      :tag => s.version,
      :submodules => true
    }

    s.swift_version = '5.0'

    s.ios.deployment_target  = '13.0'

    s.subspec 'Secp256k1' do |cs|
        cs.library = 'c++'
        cs.header_mappings_dir = 'Submodules/Secp256k1/bitcoin-core/secp256k1/'
        cs.header_dir = 'include'
        cs.public_header_files = ['Submodules/Secp256k1/bitcoin-core/secp256k1/include/*.h']
        cs.private_header_files = ['Submodules/Secp256k1/bitcoin-core/secp256k1/src/*.h']
        cs.compiler_flags =
    "-Wno-shorten-64-to-32",
#   "-Wno-conditional-uninitialized",
#   "-Wno-long-long",
#   "-Wno-overlength-strings",
    "-Wno-unused-function"
        cs.preserve_paths = 'Submodules/Secp256k1/bitcoin-core/secp256k1/{src,include}/*.{c,h}'
        cs.source_files = ['Submodules/Secp256k1/bitcoin-core/secp256k1/{src,include}/*.{c,h}']
        cs.exclude_files = [
          'Submodules/Secp256k1/bitcoin-core/secp256k1/src/test*.{c,h}',
          'Submodules/Secp256k1/bitcoin-core/secp256k1/src/*bench*.{c,h}',
          'Submodules/Secp256k1/bitcoin-core/secp256k1/src/modules/**test*.{c,h}',
          "Submodules/Secp256k1/bitcoin-core/secp256k1/contrib/*.{c, h}",
          'Submodules/Secp256k1/bitcoin-core/secp256k1/src/valgrind_ctime_test.c',
          'Submodules/Secp256k1/bitcoin-core/secp256k1/src/gen_context.c',
       ]
  
        cs.prefix_header_contents = '
  #define ECMULT_WINDOW_SIZE 15 
  #define LIBSECP256K1_CONFIG_H
  #define USE_NUM_NONE 1 
  #define ECMULT_WINDOW_SIZE 15
  #define ECMULT_GEN_PREC_BITS 4
  #define USE_FIELD_INV_BUILTIN 1
  #define USE_SCALAR_INV_BUILTIN 1
  #define HAVE_DLFCN_H 1
  #define HAVE_INTTYPES_H 1
  #define HAVE_MEMORY_H 1
  #define HAVE_STDINT_H 1
  #define HAVE_STDLIB_H 1
  #define HAVE_STRINGS_H 1
  #define HAVE_STRING_H 1
  #define HAVE_SYS_STAT_H 1
  #define HAVE_SYS_TYPES_H 1
  #define HAVE_UNISTD_H 1
  #define LT_OBJDIR ".libs/"
  #define PACKAGE "libsecp256k1"
  #define PACKAGE_BUGREPORT ""
  #define PACKAGE_NAME "libsecp256k1"
  #define PACKAGE_STRING "libsecp256k1 0.1"
  #define PACKAGE_TARNAME "libsecp256k1"
  #define PACKAGE_URL ""
  #define PACKAGE_VERSION "0.1"
  #define STDC_HEADERS 1
  #define VERSION "0.1"'
          cs.xcconfig = {
              'USE_HEADERMAP' => 'YES',
              'HEADER_SEARCH_PATHS' => '${PODS_TARGET_SRCROOT}/**',
              'USER_HEADER_SEARCH_PATHS' => '${PODS_TARGET_SRCROOT}/**'
            }
      end

    s.subspec 'VCCrypto' do |cs|
        cs.name = 'VCCrypto'
        cs.preserve_paths = 'VCCrypto/**/*.swift'
        cs.source_files= 'VCCrypto/VCCrypto/**/*.swift'
      #   cs.platform = '13.0'
        cs.dependency 'VCCore/Secp256k1'
    end 

    s.subspec 'VCToken' do |cs|
        cs.name = 'VCToken'
        cs.preserve_paths = 'VCToken/**/*.swift'
        cs.source_files= 'VCToken/VCToken/**/*.swift'
        cs.dependency 'VCCore/VCCrypto'
    end


    s.subspec 'VCEntities' do |cs|
        cs.name = 'VCEntities'
        cs.preserve_paths = 'VCEntities/**/*.swift'
        cs.source_files= 'VCEntities/VCEntities/**/*.swift'
        cs.dependency 'VCCore/VCToken'
        cs.dependency 'VCCore/VCCrypto'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
    end

    s.subspec 'VCNetworking' do |cs|
        cs.name = 'VCNetworking'
        cs.preserve_paths = 'VCNetworking/**/*.swift'
        cs.source_files= 'VCNetworking/VCNetworking/**/*.swift'
        cs.dependency 'VCCore/VCEntities'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
    end

    s.subspec 'VCNetworking' do |cs|
        cs.name = 'VCNetworking'
        cs.preserve_paths = 'VCNetworking/**/*.swift'
        cs.source_files= 'VCNetworking/VCNetworking/**/*.swift'
        cs.dependency 'VCCore/VCEntities'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
    end

    s.subspec 'VCServices' do |cs|
        cs.name = 'VCServices'
        cs.preserve_paths = 'VCServices/**/*.swift'
        cs.source_files= ['VCServices/VCServices/**/*.swift',
         'VCServices/VCServices/coreData/VerifiableCredentialDataModel.xcdatamodeld',
         'VCServices/VCServices/coreData/VerifiableCredentialDataModel.xcdatamodeld/*.xcdatamodel']
        cs.resources = [
            'VCServices/VCServices/coreData/VerifiableCredentialDataModel.xcdatamodeld',
            'VCServices/VCServices/coreData/VerifiableCredentialDataModel.xcdatamodeld/*.xcdatamodel']
        cs.preserve_paths = 'VCServices/VCServices/coreData/VerifiableCredentialDataModel.xcdatamodeld'
        cs.dependency 'VCCore/VCNetworking'
        cs.dependency 'VCCore/VCEntities'
        cs.dependency 'PromiseKit'
        # cs.ios.deployment_target  = '13.0'
    end
end
  