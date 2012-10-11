" Extra C++ stuff.

syn keyword cpp11Operator       alignof decltype
syn keyword cpp11Statement      nullptr static_assert
syn keyword cpp11StorageClass   alignas final noexcept override thread_local
syn keyword cpp11Type           char16_t char32_t constexpr

syn keyword jcppStorageClass    COLD HOT NORETURN NOTHROW PURE READPURE
syn keyword jcppType            s8 s16 s32 s64 u8 u16 u32 u64 uint RESTRICT

hi def link cpp11Operator       Operator
hi def link cpp11Statement      Statement
hi def link cpp11StorageClass   StorageClass
hi def link cpp11Type           Type
hi def link jcppStorageClass    StorageClass
hi def link jcppType            Type
