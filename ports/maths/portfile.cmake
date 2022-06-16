vcpkg_from_gitlab(
    GITLAB_URL http://gitlab.centrilliontech.com.tw:10088
    OUT_SOURCE_PATH SOURCE_PATH
    REPO centrillion/moduletemplate
    REF v0.1.0-vcpkg  # Specify the version tag or the commit SHA from the remote repository.
    SHA512  79bf4fc1f811647c4ced787b10352fb495eb806c9076e1cfbf1566226c8b15b95be5b286e9f300de77a7c5e5e52fba78a78148e8f8b9e4cd1e19696777d6d087
    # Compute the SHA512 of the tar.gz file of the REF version via 'openssl sha512 "<downloaded-file-name>.tar.gz"'
    HEAD_REF vcpkg    # Always build from the latest commit of the specified branch if the REF and SHA512 is not set.
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    # GENERATOR "MinGW Makefiles"
    # PREFER_NINJA
    OPTIONS 
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLE=ON
        -DPKG_INSTALL=ON
)

# Use CMake to install the package.
vcpkg_install_cmake() 

# Copy the mathsConfig.cmake
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/maths)

# Copy the pdb for the debugger. 
vcpkg_copy_pdbs()

# Remove the header file under the include directory of debug. (Official recommanded)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/share)

# Set the COPYRIGHT file information and output the file to the specified directory.
file(
    INSTALL ${SOURCE_PATH}/LICENSE 
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} 
    RENAME copyright
)

# Install the package:
# .\vcpkg\vcpkg.exe install maths --overlay-ports=.\vcpkg-ports\ports\maths --triplet=x64-mingw-dynamic