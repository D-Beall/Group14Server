import sqlite3
import os, glob

def eval_size(file_name):
    return os.path.getsize(file_name)

def insert_db(title, artist, folder_name):
    conn = sqlite3.connect('elixir_streaming.db')
    c = conn.cursor()

    path = '/root/projects/elixir/Group14Server/audiofiles/audiobooks/' + folder_name
    for item in glob.glob(path+'/*.mp3'):
        dnld_path = item.replace('/root/projects/elixir/Group14Server','http://xzy3.cs.seas.gwu.edu')
        file_size = eval_size(item)
        c.execute("""INSERT INTO audioinfo (title, artist, path, size) VALUES ('{}', '{}', '{}', {});""".format(title, artist, dnld_path, file_size))

    # Save (commit) the changes
    conn.commit()

    # We can also close the connection if we are done with it.
    # Just be sure any changes have been committed or they will be lost.
    conn.close()

insert_db('The Jungle Book', 'Rudyard KIPLING', 'thejunglebook_pc_librivox')
insert_db('Crome Yellow', 'Aldous Huxley', 'cromeyellow_librivox_64kb_mp3')
insert_db('The Odyssey', 'Homer and Samuel Butler', 'odyssey_butler_librivox')
