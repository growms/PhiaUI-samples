// PhiaUI JS Hooks — registered hooks for interactive components

import PhiaActionSheet from './action_sheet.js'
import PhiaAdvancedEditor from './advanced_editor.js'
import PhiaAudioPlayer from './audio_player.js'
import PhiaAutoresize from './autoresize.js'
import PhiaBackTop from './back_top.js'
import PhiaBubbleMenu from './bubble_menu.js'
import PhiaCalendar from './calendar.js'
import PhiaCardSpotlight from './card_spotlight.js'
import PhiaCarousel from './carousel.js'
import { PhiaCascader } from './cascader.js'
import PhiaChart from './chart.js'
import PhiaChartCrosshair from './chart_crosshair.js'
import PhiaChartSync from './chart_sync.js'
import PhiaChatTextarea from './chat_textarea.js'
import PhiaCheckboxTree from './checkbox_tree.js'
import PhiaCodeSnippet from './code_snippet.js'
import PhiaCodeTextarea from './code_textarea.js'
import PhiaColorPicker from './color_picker.js'
import PhiaCommand from './command.js'
import PhiaConfetti from './confetti.js'
import PhiaConfirmButton from './confirm_button.js'
import PhiaContextMenu from './context_menu.js'
import PhiaCopyButton from './copy_button.js'
import PhiaCountdownButton from './countdown_button.js'
import PhiaCreditCard from './credit_card.js'
import PhiaDarkMode from './dark_mode.js'
import PhiaDataGrid from './data_grid.js'
import PhiaDataZoom from './data_zoom.js'
import PhiaDateRangePicker from './date_range_picker.js'
import PhiaDialog from './dialog.js'
import PhiaDragNumber from './drag_number.js'
import PhiaDraggableTree from './draggable_tree.js'
import PhiaDrawer from './drawer.js'
import { PhiaDropZone, PhiaDragTransferList } from './drop_zone.js'
import PhiaDropdownMenu from './dropdown_menu.js'
import PhiaEditable from './editable.js'
import PhiaEditorColorPicker from './editor_color_picker.js'
import PhiaEditorDropdown from './editor_dropdown.js'
import PhiaEditorFindReplace from './editor_find_replace.js'
import PhiaEmojiPicker from './emoji_picker.js'
import PhiaFlickerGrid from './flicker_grid.js'
import PhiaFloatingMenu from './floating_menu.js'
import PhiaFocusTrap from './focus_trap.js'
import PhiaFullscreenDrop from './fullscreen_drop.js'
import PhiaGlobalMessage from './global_message.js'
import PhiaGridExport from './grid_export.js'
import PhiaHoverCard from './hover_card.js'
import PhiaImageComparison from './image_comparison.js'
import PhiaKanban from './kanban.js'
import PhiaKeyShortcut from './keyboard_shortcut.js'
import PhiaLazyTree from './lazy_tree.js'
import PhiaLightbox from './lightbox.js'
import PhiaMagicCard from './magic_card.js'
import PhiaMarkdownEditor from './markdown_editor.js'
import PhiaMarquee from './marquee.js'
import { PhiaMaskedInput } from './masked_input.js'
import PhiaMegaMenu from './mega_menu.js'
import PhiaMentionInput from './mention_input.js'
import PhiaMeshBg from './mesh_bg.js'
import PhiaMultiDrag from './multi_drag.js'
import PhiaNumberTicker from './number_ticker.js'
import PhiaPageProgress from './page_progress.js'
import PhiaParticleBg from './particle_bg.js'
import PhiaPopover from './popover.js'
import { PhiaRangeSlider } from './range_slider.js'
import PhiaResizable from './resizable.js'
import PhiaRichTextEditor from './rich_text_editor.js'
import PhiaScrollReveal from './scroll_reveal.js'
import { PhiaSignaturePad } from './signature_pad.js'
import PhiaSlashCommand from './slash_command.js'
import PhiaSonner from './sonner.js'
import PhiaSortable from './sortable.js'
import PhiaSortableGrid from './sortable_grid.js'
import PhiaSpeedDial from './speed_dial.js'
import PhiaSplitButton from './split_button.js'
import PhiaSplitInput from './split_input.js'
import PhiaSpotlight from './spotlight.js'
import PhiaSuggestionInput from './suggestion_input.js'
import PhiaTagsInput from './tags_input.js'
import PhiaTextScramble from './text_scramble.js'
import PhiaTheme from './theme.js'
import PhiaTiltCard from './tilt_card.js'
import PhiaToast from './toast.js'
import PhiaToc from './toc.js'
import PhiaTooltip from './tooltip.js'
import PhiaTreeSelect from './tree_select.js'
import PhiaTypewriter from './typewriter.js'
import PhiaVideoPlayer from './video_player.js'
import PhiaVirtualTree from './virtual_tree.js'
import PhiaWordRotate from './word_rotate.js'

const PhiaHooks = {
  PhiaActionSheet,
  PhiaAdvancedEditor,
  PhiaAudioPlayer,
  PhiaAutoresize,
  PhiaBackTop,
  PhiaBubbleMenu,
  PhiaCalendar,
  PhiaCardSpotlight,
  PhiaCarousel,
  PhiaCascader,
  PhiaChart,
  PhiaChartCrosshair,
  PhiaChartSync,
  PhiaChatTextarea,
  PhiaCheckboxTree,
  PhiaCodeSnippet,
  PhiaCodeTextarea,
  PhiaColorPicker,
  PhiaCommand,
  PhiaConfetti,
  PhiaConfirmButton,
  PhiaContextMenu,
  PhiaCopyButton,
  PhiaCountdownButton,
  PhiaCreditCard,
  PhiaDarkMode,
  PhiaDataGrid,
  PhiaDataZoom,
  PhiaDateRangePicker,
  PhiaDialog,
  PhiaDragNumber,
  PhiaDragTransferList,
  PhiaDraggableTree,
  PhiaDrawer,
  PhiaDropZone,
  PhiaDropdownMenu,
  PhiaEditable,
  PhiaEditorColorPicker,
  PhiaEditorDropdown,
  PhiaEditorFindReplace,
  PhiaEmojiPicker,
  PhiaFlickerGrid,
  PhiaFloatingMenu,
  PhiaFocusTrap,
  PhiaFullscreenDrop,
  PhiaGlobalMessage,
  PhiaGridExport,
  PhiaHoverCard,
  PhiaImageComparison,
  PhiaKanban,
  PhiaKeyShortcut,
  PhiaLazyTree,
  PhiaLightbox,
  PhiaMagicCard,
  PhiaMarkdownEditor,
  PhiaMarquee,
  PhiaMaskedInput,
  PhiaMegaMenu,
  PhiaMentionInput,
  PhiaMeshBg,
  PhiaMultiDrag,
  PhiaNumberTicker,
  PhiaPageProgress,
  PhiaParticleBg,
  PhiaPopover,
  PhiaRangeSlider,
  PhiaResizable,
  PhiaRichTextEditor,
  PhiaScrollReveal,
  PhiaSignaturePad,
  PhiaSlashCommand,
  PhiaSonner,
  PhiaSortable,
  PhiaSortableGrid,
  PhiaSpeedDial,
  PhiaSplitButton,
  PhiaSplitInput,
  PhiaSpotlight,
  PhiaSuggestionInput,
  PhiaTagsInput,
  PhiaTextScramble,
  PhiaTheme,
  PhiaTiltCard,
  PhiaToast,
  PhiaToc,
  PhiaTooltip,
  PhiaTreeSelect,
  PhiaTypewriter,
  PhiaVideoPlayer,
  PhiaVirtualTree,
  PhiaWordRotate,
}

export default PhiaHooks
