vcpkg_from_gitlab(
    GITLAB_URL http://gitlab.centrilliontech.com.tw:10088
    OUT_SOURCE_PATH SOURCE_PATH
    REPO centrillion/remoterepo
    REF v0.1.0-vcpkg  # Specify the version tag or the commit SHA from the remote repository.
    SHA512  f05fe51888b21c4f30ee898e4ff4cd32a913ca8660487b3e4d1679ff60fdc4db2449d02a4797db5c7682e0de9c520a7fb307e90091c9ab274d33988624947cef
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
)

# Use CMake to install the package.
vcpkg_install_cmake() 

# Copy the MathsConfig.cmake
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Maths)

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