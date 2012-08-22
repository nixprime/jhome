" Extra C++ stuff.

syn keyword cpp11Operator       alignof decltype
syn keyword cpp11Statement      nullptr static_assert
syn keyword cpp11StorageClass   alignas final noexcept override thread_local
syn keyword cpp11Type           char16_t char32_t constexpr

syn keyword jlcppStorageClass   COLD HOT NOTHROW PURE READPURE
syn keyword jlcppType           i8 i16 i32 i64 u8 u16 u32 u64 byte RESTRICT

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cpp11Operator      Operator
  HiLink cpp11Statement     Statement
  HiLink cpp11StorageClass  StorageClass
  HiLink cpp11Type          Type
  HiLink jlcppStorageClass  StorageClass
  HiLink jlcppType          Type
  delcommand HiLink
endif

