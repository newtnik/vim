" CVSconflict: a vimdiff-based way to view and edit cvs-conflict containing files
" Author:	Charles E. Campbell
" Date:		Nov 19, 2013
" Version:	2i	ASTRO-ONLY
" Copyright:    Copyright (C) 2005-2011 Charles E. Campbell {{{1
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               CVSconflict.vim is provided *as is* and comes with no warranty
"               of any kind, either expressed or implied. By using this
"               plugin, you agree that in no event will the copyright
"               holder be liable for any damages resulting from the use
"               of this software.
" GetLatestVimScripts: 1370 1 :AutoInstall: CVSconflict.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_CVSconflict") || &cp
 finish
endif
let g:loaded_CVSconflict = "v2i"
let s:keepcpo            = &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Load <cvscommand.vim> If Possible: {{{1
silent! run plugin/cvscommand.vim

" ---------------------------------------------------------------------
"  Public Interface:	{{{1
com! CVSconflict	call <SID>CVSconflict()
amenu <silent> .23 &Plugin.CVS\ Con&flict :CVSconflict<cr>

" ---------------------------------------------------------------------
" CVSconflict: this function splits the current, presumably {{{1
"              cvs-conflict'ed file into two versions, and then applies
"              vimdiff.  The original file is left untouched.
fun! s:CVSconflict()
  "call Dfunc("CVSconflict()")

  " sanity check
  if !search('^>>>>>>>','nw')
   echo "***CVSconflict*** no cvs-conflicts present"
   "call Dret("CVSconflict")
   return
  endif

  " some quick write local/repo, left/right window writing commands
  " one can also  :W  the current buffer as the selected buffer
  com! CVSwL     sil wincmd h | exe "w! ".s:curfile | exe "file ".s:curfile
  com! CVSleft   sil wincmd h | exe "w! ".s:curfile | exe "file ".s:curfile
  com! CVSlocal  sil wincmd h | exe "w! ".s:curfile | exe "file ".s:curfile
  sil! com Lgood sil wincmd h | exe "w! ".s:curfile | exe "file ".s:curfile
                       
  com! CVSwR     sil wincmd l | exe "w! ".s:curfile | exe "file ".s:curfile
  com! CVSright  sil wincmd l | exe "w! ".s:curfile | exe "file ".s:curfile
  com! CVSrepo   sil wincmd l | exe "w! ".s:curfile | exe "file ".s:curfile
  sil! com Rgood sil wincmd l | exe "w! ".s:curfile | exe "file ".s:curfile

  " construct Local and Repo files
  let curfile   = expand("%")
  let s:curfile = curfile
  if curfile =~ '\.'
   let fileLocal = substitute(curfile,'\.[^.]\+$','Local&','')
   let fileRepo  = substitute(curfile,'\.[^.]\+$','Repo&','')
  else
   let fileLocal = curfile."Local"
   let fileRepo  = curfile."Repo"
  endif

  " check if fileLocal or fileRepo already exists (as a file).  Although CVSconflict
  " doesn't write these files, I don't want to have a user inadvertently
  " writing over such a file.
  if filereadable(fileLocal)
   echohl WarningMsg | echo "***CVSconflict*** ".fileLocal." already exists!"
   "call Dret("CVSconflict")
   return
  endif
  if filereadable(fileRepo)
   echohl WarningMsg | echo "***CVSconflict*** ".fileRepo." already exists!"
   "call Dret("CVSconflict")
   return
  endif

  " make two windows with separate copies of curfile, named fileLocal and fileRepo
  silent vsplit
  let ft=&ft
  exe "silent file ".fileLocal

  wincmd l
  enew
  exe "r ".curfile
  keepj 0d
  exe "silent file ".fileRepo
  let &ft=ft

  " fileLocal: remove
  "   =======
  "   ...
  "   >>>>>>>
  " sections, and remove the <<<<<<< line
  wincmd h
  silent g/^=======/.;/^>>>>>>>/d
  silent g/^<<<<<<</d
  com! -buffer W	exe "w! ".s:curfile | exe "file ".s:curfile
  set nomod

  " fileRepo: remove
  "   >>>>>>>
  "   ...
  "   =======
  " sections, and remove the <<<<<<< line
  wincmd l
  silent g/^<<<<<<</.;/^=======/d
  silent g/^>>>>>>>/d
  com! -buffer W	exe "w! ".s:curfile | exe "file ".s:curfile
  set nomod

  " set up vimdiff'ing
  diffthis
  wincmd h
  diffthis
  echomsg "  :W  will save contents from current window to <".s:curfile.">"

  "call Dret("CVSconflict")
endfun

" ---------------------------------------------------------------------
"  Restore Cpo: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=4 fdm=marker
