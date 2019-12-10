# embedded_python.vim

```
if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

" enter 'source %' then enter 'call Hello()' to run this function
function! Hello()
python << endpython

Python Code Here...

endpython
endfunction
```
