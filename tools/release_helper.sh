# Simple tool to help for release
# when releasing with bash, simplei source it to get asked questions. 

echo -n 'PREV_RELEASE (X.y.z):'
read PREV_RELEASE
echo -n 'MILESTONE (X.y):'
read MILESTONE
echo -n 'VERSION (X.y.z):'
read VERSION
echo -n 'branch (master|X.y):'
read branch

RED=$(tput setaf 1)
NOR=$(tput sgr0)

echo 
echo "updating what's new with informations from docs/source/whatsnew/pr"
python tools/update_whatsnew.py

echo
echo "please move the contents of "docs/source/whatsnew/development.rst" to version-X.rst"
echo "Press enter to continue"
read

echo 
echo "here are all the authors that contributed to this release:"
git log --format="%aN <%aE>" $PREV_RELEASE... | sort -u -f

echo 
echo "If you see any duplicates cancel (Ctrl-C), then edit .mailmap" Press enter to continue
read

echo "generating stats"
python tools/github_stats.py --milestone $MILESTONE > stats.rst

echo "stats.rst files generated. Please merge it with the right file (github-stats-X.rst)"
echo "press enter to continue."
read

echo "Cleaning repository"
git clean -xfdi

echo "please update version number in ${RED}IPython/core/release.py${NOR} , Do not commit
yet – we'll do it later."

echo "Press enter to continue"
read

echo 
echo "Attempting to build the docs.."
make html -C docs

echo 
echo "Check the docs, press enter to continue"
read

echo
echo "Attempting to build package..."

tools/build_release

echo
echo "Let\'s commit : git commit -am \"release $VERSION\" -S"
echo "Press enter to continue"
read
git commit -am "release $VERSION"

