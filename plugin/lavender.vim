" lavender.vim
" Author: Łukasz Langa
" Created: Mon Mar 26 23:27:53 2018 -0700
" Requires: Vim Ver7.0+
" Version:  1.1
"
" Documentation:
"   This plugin formats Python files.
"
" History:
"  1.0:
"    - initial version
"  1.1:
"    - restore cursor/window position after formatting

if v:version < 700 || !has('python3')
    echo "This script requires vim7.0+ with Python 3.6 support."
    finish
endif

if exists("g:load_lavender")
   finish
endif

let g:load_lavender = "py1.0"
if !exists("g:lavender_virtualenv")
  if has("nvim")
    let g:lavender_virtualenv = "~/.local/share/nvim/lavender"
  else
    let g:lavender_virtualenv = "~/.vim/lavender"
  endif
endif
if !exists("g:lavender_fast")
  let g:lavender_fast = 0
endif
if !exists("g:lavender_linelength")
  let g:lavender_linelength = 99
endif
if !exists("g:lavender_string_normalization")
  let g:lavender_string_normalization = "single"
endif

python3 << endpython3
import os
import sys
import vim

def _get_python_binary(exec_prefix):
  try:
    default = vim.eval("g:pymode_python").strip()
  except vim.error:
    default = ""
  if default and os.path.exists(default):
    return default
  if sys.platform[:3] == "win":
    return exec_prefix / 'python.exe'
  return exec_prefix / 'bin' / 'python3'

def _get_pip(venv_path):
  if sys.platform[:3] == "win":
    return venv_path / 'Scripts' / 'pip.exe'
  return venv_path / 'bin' / 'pip'

def _get_virtualenv_site_packages(venv_path, pyver):
  if sys.platform[:3] == "win":
    return venv_path / 'Lib' / 'site-packages'
  return venv_path / 'lib' / f'python{pyver[0]}.{pyver[1]}' / 'site-packages'

def _initialize_lavender_env(upgrade=False):
  pyver = sys.version_info[:2]
  if pyver < (3, 6):
    print("Sorry, Lavender requires Python 3.6+ to run.")
    return False

  from pathlib import Path
  import subprocess
  import venv
  virtualenv_path = Path(vim.eval("g:lavender_virtualenv")).expanduser()
  virtualenv_site_packages = str(_get_virtualenv_site_packages(virtualenv_path, pyver))
  first_install = False
  if not virtualenv_path.is_dir():
    print('Please wait, one time setup for Lavender.')
    _executable = sys.executable
    try:
      sys.executable = str(_get_python_binary(Path(sys.exec_prefix)))
      print(f'Creating a virtualenv in {virtualenv_path}...')
      print('(this path can be customized in .vimrc by setting g:lavender_virtualenv)')
      venv.create(virtualenv_path, with_pip=True)
    finally:
      sys.executable = _executable
    first_install = True
  if first_install:
    print('Installing Lavender with pip...')
  if upgrade:
    print('Upgrading Lavender with pip...')
  if first_install or upgrade:
    subprocess.run([str(_get_pip(virtualenv_path)), 'install', '-U', 'lavender'], stdout=subprocess.PIPE)
    print('DONE! You are all set, thanks for waiting ✨ 🍰 ✨')
  if first_install:
    print('Pro-tip: to upgrade Lavender in the future, use the :LavenderUpgrade command and restart Vim.\n')
  if virtualenv_site_packages not in sys.path:
    sys.path.append(virtualenv_site_packages)
  return True

if _initialize_lavender_env():
  import lavender
  import time

def Lavender():
  start = time.time()
  fast = bool(int(vim.eval("g:lavender_fast")))
  mode = lavender.FileMode(
    line_length=int(vim.eval("g:lavender_linelength")),
    string_normalization=vim.eval("g:lavender_string_normalization"),
    is_pyi=vim.current.buffer.name.endswith('.pyi'),
  )
  buffer_str = '\n'.join(vim.current.buffer) + '\n'
  try:
    new_buffer_str = lavender.format_file_contents(buffer_str, fast=fast, mode=mode)
  except lavender.NothingChanged:
    print(f'Already well formatted, good job. (took {time.time() - start:.4f}s)')
  except Exception as exc:
    print(exc)
  else:
    current_buffer = vim.current.window.buffer
    cursors = []
    for i, tabpage in enumerate(vim.tabpages):
      if tabpage.valid:
        for j, window in enumerate(tabpage.windows):
          if window.valid and window.buffer == current_buffer:
            cursors.append((i, j, window.cursor))
    vim.current.buffer[:] = new_buffer_str.split('\n')[:-1]
    for i, j, cursor in cursors:
      window = vim.tabpages[i].windows[j]
      try:
        window.cursor = cursor
      except vim.error:
        window.cursor = (len(window.buffer), 0)
    print(f'Reformatted in {time.time() - start:.4f}s.')

def LavenderUpgrade():
  _initialize_lavender_env(upgrade=True)

def LavenderVersion():
  print(f'Lavender, version {lavender.__version__} on Python {sys.version}.')

endpython3

command! Lavender :py3 Lavender()
command! LavenderUpgrade :py3 LavenderUpgrade()
command! LavenderVersion :py3 LavenderVersion()
