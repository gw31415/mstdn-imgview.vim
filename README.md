# mstdn-imgview.vim

Image viewer through sixel of [mstdn.vim](https://github.com/gw31415/mstdn.vim).

## Requirements

- A terminal or environment capable of displaying sixel graphics (for example,
  some terminals like XTerm with sixel support, or Wezterm, etc.).
- [mstdn.vim](https://github.com/gw31415/mstdn.vim) as the backend plugin that communicates with Mastodon.
- [denops-sixel-view.vim](https://github.com/gw31415/denops-sixel-view.vim) as the sixel backend plugin.

## Usage

Call `mstdn#imgview#view(+1)` to see the images which are the post's attachments.

## API

For more information, read the [doc](./doc/mstdn-imgview.txt).

### Function(s)

| Function                    | Description                                                                                                                     |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `mstdn#imgview#view(next)`  | Display the image associated with the post under the cursor that is only next to the currently displayed image's `next` number. |
| `mstdn#imgview#clear()`     | Clear the image view.                                                                                                           |

### Variable(s)

| Variable                     | Description                                                                                 |
| -----------------------------|-------------------------------------------------------------------------------------------- |
| `g:mstdn_imgview_fontheight` | The fontsize of your GUI Terminal app. Default value is gotten from `guifont` or `14`.      |
| `g:mstdn_imgview_fontwidth`  | The font width of your GUI Terminal app. Default value is `g:mstdn_imgview_fontheight / 2`. |
| `g:mstdn_imgview_retinascale`| The ratio of the screen's logical pixel size to the actual pixel size. It tries to get automatically. If failed, the default value will be `1` |

## Related projects

- [`gw31415/mstdn.vim`](https://github.com/gw31415/mstdn.vim): The dependent
  plugin. The backend through which this plugin communicates with Mastodon.
