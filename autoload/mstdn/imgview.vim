function mstdn#imgview#clear() abort
	if exists('b:mstdn_imgview_index')
		unlet b:mstdn_imgview_index
	endif
	call sixel_view#clear()
endfunction

function s:get_attachments() abort
	let mode = &ft
	if mode == 'mstdn'
		return mstdn#timeline#status()['mediaAttachments']
	elseif mode == 'mstdn-editor'
		let user = mstdn#editor#get_user()
		let ids = get(mstdn#editor#get_statusparams(), "media_ids", [])
		let medias = mapnew(ids, {_, v -> denops#request('mstdn', 'requestMstdn', [user, '/api/v1/media/' .. v, 'GET', v:null])})
		return medias
	endif

	return []
endfunction

function mstdn#imgview#view(next) abort
	let guifontsize = matchstr(&guifont, '\d\+')
	let fontheight = exists('g:mstdn_imgview_fontheight') ? g:mstdn_imgview_fontheight : ( strlen(guifontsize) > 0 ? str2nr(guifontsize) : 14)
	let fontwidth = exists('g:mstdn_imgview_fontwidth') ? g:mstdn_imgview_fontwidth : ( fontheight / 2 )
	let retinascale = exists('g:mstdn_imgview_retinascale') ? g:mstdn_imgview_retinascale : denops#request('mstdn-imgview', 'getRetinaScale', [])
	let ww = winwidth(win_getid(1))
	let wh = winheight(win_getid(1))
	let wwpx = ww * fontwidth * retinascale
	let whpx = wh * fontheight * retinascale
	let maxWidth = wwpx - ( fontwidth * 10 )
	let maxHeight = whpx - ( fontheight * 10 )
	if maxWidth < 0
		echoerr "Too small window width"
		return
	endif
	if maxHeight < 0
		echoerr "Too small window height"
		return
	endif

	let imgs = s:get_attachments()->filter({_, v -> v['type'] == 'image'})
	if len(imgs) == 0
		echoerr "No image found"
		return
	endif

	if !exists('b:mstdn_imgview_index')
		let b:mstdn_imgview_index = 0
	else
		let b:mstdn_imgview_index = b:mstdn_imgview_index + a:next
	endif
	let index = b:mstdn_imgview_index % len(imgs)
	if index < 0
		let index = len(imgs) + index
	endif

	let key = 'preview_url' " or 'url'
	let url = imgs[index][key]
	
	let sixel = sixel_view#img2sixel(url, #{maxWidth: maxWidth, maxHeight: maxHeight})

	let cnum = max([float2nr(( wwpx - sixel['width'] ) / 2 / fontwidth / retinascale), 5])
	let lnum = float2nr(( whpx - sixel['height'] ) / 2 / fontheight / retinascale)
	
	call sixel_view#view_sixel(sixel['data'], lnum, cnum)
	au CursorMoved,CursorMovedI,BufLeave <buffer> ++once call mstdn#imgview#clear()
endfunction
