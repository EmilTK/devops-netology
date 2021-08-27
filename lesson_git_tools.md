### Домашняя работа к занятию «2.4. Инструменты Git»

**1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea**
   
   Вывод информации по коммиту `git show aefea`
>  SHA-1: aefead2207ef7e2aa5dc81a34aedf0cad4c32545 
>  comment: Update CHANGELOG.md

**2. Какому тегу соответствует коммит 85024d3?**
  
   Вывод информации по коммиту  `git show 85024d3`
> tag: v0.12.23

**3. Сколько родителей у коммита b8d720? Напишите их хеши.**
    
`git show b8d720`<br>
По какой-то причине при вызове git show b8d720^ получаю ошибку "ничего не найдено"
> 56cd7859e<br>
> 9ea88f22f

**4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.**

Поиск всех коммитов между тегами: `git log --pretty=format:"%h: %s" v0.12.23..v0.12.24`

> 33ff1c03b: v0.12.24<br>
> b14b74c49: [Website] vmc provider links<br>
> 3f235065b: Update CHANGELOG.md<br>
> 6ae64e247: registry: Fix panic when server is unreachable<br>
> 5c619ca1b: website: Remove links to the getting started guide's old location<br>
> 06275647e: Update CHANGELOG.md<br>
> d5f9411f5: command: Fix bug when using terraform login on Windows<br>
> 4b6d06cc5: Update CHANGELOG.md<br>
> dd01a3507: Update CHANGELOG.md<br>
> 225466bc3: Cleanup after v0.12.23 release<br>

**5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).**

Поиск первого обозначения функции: `git log -S "func providerSource" --oneline`  
Проверка функции в коммите: `git show 8c928e835`

> 8c928e835

**6. Найдите все коммиты в которых была изменена функция globalPluginDirs**.

Поиск всех файлов, где встречается globalPluginDirs: `git grep -c globalPluginDirs`<br>
Поиск внесенных изменений в функцию: `git log -L:globalPluginDirs:plugins.go --oneline`
>  78b122055<br>
>  52dbf9483<br>
>  52dbf9483<br>
>  66ebff90c<br>
>  8364383c3<br>

**7. Кто автор функции synchronizedWriters?**

Поиск первого обозначения функции: `git log -S synchronizedWriters`<br>
Проверка функции в коммите: `git show 5ac311e2a`
> Author: Martin Atkins <mart@degeneration.co.uk>