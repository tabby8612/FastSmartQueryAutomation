import "./editor.css"

import Link from '@tiptap/extension-link'
import { TextAlign } from '@tiptap/extension-text-align'
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import EditorToolbar from './editor-toolbar'

interface Props {
    content: string,
    onChangeFn: (content: string) => void
}

const RichTextEditor = ({content, onChangeFn, ...props}: Props & React.ComponentProps<"div">) => {
    const editor = useEditor({
        extensions: [StarterKit.configure({
            heading: {
                levels: [1, 2, 3],
                HTMLAttributes: {
                    class: "text-lg font-bold"
                }
            },
            bulletList: {
                HTMLAttributes: {
                    class: ""
                }
            }
        }),
        TextAlign.configure({
            types: ["heading", "paragraph"],
            alignments: ['left', 'center', 'right'],
            defaultAlignment: "left"
        }),

        ],
        content: content,

        onUpdate: ({ editor }) => {
            onChangeFn(editor.getHTML())
        },

        editorProps: {
            attributes: {
                class: 'prose dark:prose-invert max-w-none p-4 min-h-[250px] outline-none focus:outline-none',
            },
        },
    })

    if (!editor) return null

    return (
        <>
            <div className='w-full border border-gray-200 dark:border-gray-800 rounded-xl shadow-sm bg-white  overflow-hidden"'>
                <EditorToolbar editor={editor} />
                <EditorContent editor={editor} className='editor-content' {...props}/>


            </div>
        </>
    )
}

export default RichTextEditor