from setuptools import setup
import os

# Handle the long description (read from README.txt, which is created by converting README.md)
long_description = 'bully hunter'

exec(open('bullyhunter/_version.py').read())


setup(

    # Package structure
    #
    # find_packages searches through a set of directories 
    # looking for packages
    #packages = find_packages('util', exclude = ['*.tests', '*.tests.*', 'tests.*', 'tests']),
    
    # package_dir directive maps package names to directories.
    # package_name:package_directory
    packages = ['bullyhunter'],
    # Not all packages are capable of running in compressed form, 
    # because they may expect to be able to access either source 
    # code or data files as normal operating system files.
    zip_safe = False,

    # Entry points
    #
    # install the executable

    # entry_points = {
    #    'console_scripts': ['tstables_benchmark = tstables.Benchmark:main']
    #},

    # Dependencies
    #
    # Dependency expressions have a package name on the left-hand 
    # side, a version on the right-hand side, and a comparison 
    # operator between them, e.g. == exact version, >= this version
    # or higher
    #install_requires = ['tables>=3.1.1', 'pandas>=0.13.1'],

    # Tests
    #
    # Tests must be wrapped in a unittest test suite by either a
    # function, a TestCase class or method, or a module or package
    # containing TestCase classes. If the named suite is a package,
    # any submodules and subpackages are recursively added to the
    # overall test suite.

    #test_suite = 'as_run_log.tests.suite',

    # Download dependencies in the current directory
    #tests_require = 'docutils >= 0.6',

    name = "bullyfighter",
    version = __version__,

    # metadata for upload to PyPI
    author = "Jean Luo",
    author_email = "jl3984@att.com",
    #description = "",
    #license = "",
    #keywords = "",
    #url = "",   # project home page, if any
    long_description = long_description
    # could also include download_url, classifiers, etc.
)
