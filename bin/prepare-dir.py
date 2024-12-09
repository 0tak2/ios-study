import sys
import os

# 디렉토리 구성을 바꾸려면 다음 리스트를 변경
CHILD_DIRS = ["notes", "projects", "assets"]
# notes: 필기
# projects: 실습 프로젝트
# assets: 실습에 필요한 파일들

def makeDir(dir_name: str):
  try:
    os.mkdir(dir_name)
    print(dir_name + "을 잘 만들었습니다.")
  except OSError as e:
    print(e)

def writeFile(dir_name: str, file_name: str, contents: str):
  full_path = os.path.join(dir_name, file_name)
  f = open(full_path, 'w')
  f.write(contents)
  f.close()
  print(full_path + "를 잘 작성했습니다.")

def makeParentDir(dir_name: str):
  makeDir(dir_name)

  readme_content = f"# {dir_name}\n"
  writeFile(dir_name, "README.md", readme_content)

def makeChildDirs(parent_dir_name: str):
  for dir in CHILD_DIRS:
    child_dir_name = os.path.join(parent_dir_name, dir)
    makeDir(child_dir_name)
    writeFile(child_dir_name, ".gitkeep", "")

def main():
  if len(sys.argv) != 2:
    usage_text = '''인자가 부족합니다.

[Usage]
python prepare-dir.py [생성할 디렉토리 이름]
'''
    print(usage_text)
    sys.exit()

  dir_path = sys.argv[1]
  makeParentDir(dir_path)
  makeChildDirs(dir_path)

main()
