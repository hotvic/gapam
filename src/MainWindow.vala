/*
 * Copyright (c) 2015 Victor A. Santos <victoraur.santos@gmail.com>
 *
 * This file is part of GAPAM.
 *
 * GAPAM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * GAPAM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GAPAM.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;

/* single instance pointer */
public static Gapam.MainWindow main_window;

namespace Gapam {
    public enum FilesColumns {
        NAME,
        SIZE,
        MODE,
        MTIME,
        BIRTHTIME,
        LAST
    }

    [GtkTemplate (ui="/org/gapam/archivemanager/gtk/appwindow.ui")]
    public class MainWindow : Gtk.ApplicationWindow {
        [GtkChild]
        private TreeView tv_files;

        public TreeView w_tv_files {
            get { return tv_files; }
        }

        public MainWindow(Gtk.Application? app) {
            Object(application: app);

            this.add_actions();
        }

        public void add_actions() {
            var _new = new SimpleAction("new", null);
            var open = new SimpleAction("open", null);

            _new.activate.connect(this.act_open);
            open.activate.connect(this.act_open);

            this.add_action(_new);
            this.add_action(open);
        }

        public void act_new() {

        }

        public void act_open() {
            var dialog = new FileChooserDialog("Select a archive file", this, Gtk.FileChooserAction.OPEN,
                                               "_Cancel", Gtk.ResponseType.CANCEL,
                                               "_Open", Gtk.ResponseType.ACCEPT);

            if (dialog.run() == Gtk.ResponseType.ACCEPT) {
                (this.application as Gapam.Application).open_archive(dialog.get_filename());
            }

            dialog.close();
        }
    }
}
