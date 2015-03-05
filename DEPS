# This file contains dependencies for WebRTC that are not shared with Chromium.
# If you wish to add a dependency that is present in Chromium's src/DEPS or a
# directory from the Chromium checkout, you should add it to setup_links.py
# instead.

vars = {
  'extra_gyp_flag': '-Dextra_gyp_flag=0',
  'chromium_git': 'https://chromium.googlesource.com',
  'chromium_revision': '4664fe0d123f948bafa7b942717fc5847e61971c',
}

# NOTE: Prefer revision numbers to tags for svn deps. Use http rather than
# https; the latter can cause problems for users behind proxies.
deps = {
  # When rolling gflags, also update
  # https://chromium.googlesource.com/chromium/deps/webrtc/webrtc.DEPS
  'src/third_party/gflags/src':
    Var('chromium_git') + '/external/gflags/src@e7390f9185c75f8d902c05ed7d20bb94eb914d0c', # from svn revision 82

  'src/third_party/junit':
    Var('chromium_git') + '/external/junit@64155f8a9babcfcf4263cf4d08253a1556e75481',

  'src/strukturag-inhouse/inhouse-deps/nss':
    Var('chromium_git') + '/chromium/deps/nss@87b96db4268293187d7cf741907a6d5d1d8080e0' # NSS 3.16.7.
}

deps_os = {
  'win': {
    'src/third_party/winsdk_samples/src':
      Var('chromium_git') + '/external/webrtc/deps/third_party/winsdk_samples_v71@c0cbedd854cb610a53226d9817416c4ab9a7d1e9', # from svn revision 7951
  },
}

# Define rules for which include paths are allowed in our source.
include_rules = [
  # Base is only used to build Android APK tests and may not be referenced by
  # WebRTC production code.
  '-base',
  '-chromium',
  '+gflags',
  '+net',
  '+talk',
  '+testing',
  '+third_party',
  '+webrtc',
]

# checkdeps.py shouldn't check include paths for files in these dirs:
skip_child_includes = [
  'webrtc/overrides',
]

hooks = [
  {
    # Check for legacy named top-level dir (named 'trunk').
    'name': 'check_root_dir_name',
    'pattern': '.',
    'action': ['python','-c',
               ('import os,sys;'
                'script = os.path.join("trunk","check_root_dir.py");'
                '_ = os.system("%s %s" % (sys.executable,script)) '
                'if os.path.exists(script) else 0')],
  },
  {
    # Clone chromium and its deps.
    'name': 'sync chromium',
    'pattern': '.',
    'action': ['python', '-u', 'src/sync_chromium.py',
               '--target-revision', Var('chromium_revision')],
  },
  {
    # Create links to shared dependencies in Chromium.
    'name': 'setup_links',
    'pattern': '.',
    'action': ['python', 'src/setup_links.py'],
  },
  {
    # Apply patches, setup links for inhouse changes. This should be done after setup_links hook
    'name': 'apply_inhouse_patches',
    'pattern': '.',
    'action': ['python', 'src/strukturag-inhouse/apply-inhouse-patches.py'],
  },
  {
    # Make a symbolic link for build script in parent dir
    'name': 'link build script',
    'pattern': '.',
    'action': ['ln', '-fs', 'src/strukturag-inhouse/make-webrtc.sh', 'make-webrtc.sh'],
  },

  # We don't need this step since build script will do it anyway. Commenting out for now.
  #{
    ## A change to a .gyp, .gypi, or to GYP itself should run the generator.
    #'name': 'gyp',
    #'pattern': '.',
    #'action': ['python', 'src/webrtc/build/gyp_webrtc',
    #           Var('extra_gyp_flag')],

  #},
]

