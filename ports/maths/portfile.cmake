vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jeff665547/Module-Template
    REF v0.1.0-vcpkg  # Specify the version tag or the commit SHA from the remote repository.
    SHA512  24e929bb184221a4a3dc5ed16f5746a6c28cbe668fdfbc7c0814410afed00909664c681ce93a6eafc0d40baf52c9445e6bdd8ae1467cb2cee617ac8be30964b2
    # Compute the SHA512 of the tar.gz file of the REF version via 'openssl sha512 "<downloaded-file-name>.tar.gz"'
    HEAD_REF vcpkg    # Always build from the latest commit of the specified branch if the REF and SHA512 is not set.
    PATCHES
        disable-the-example-executable.patch
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