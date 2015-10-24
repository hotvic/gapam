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


namespace Gapam {
    public class Application : Gtk.Application {
        private Archive.Read archive = null;

        public Application() {
            Object(application_id: "org.gapam.archivemanager", flags: 0);

            Environment.set_application_name("GAPAM");

            add_actions();
        }

        public override void activate() {
            main_window.show_all();
            main_window.destroy.connect(() => {
                this.quit();
            });
        }

        public override void startup() {
            base.startup();

            main_window = new MainWindow(this);
            pref_window = new Preferences();
        }

        public override void shutdown() {
            base.shutdown();
        }

        public void open_archive(string filename) {
            archive = new Archive.Read();

            archive.support_filter_all();
            archive.support_format_all();

            archive.open_filename(filename, 262144);

            var model = new Gtk.TreeStore(FilesColumns.LAST, typeof(string),
                                          typeof(string), typeof(string),
                                          typeof(string), typeof(string));

            unowned Archive.Entry entry;

            while(archive.next_header(out entry) == Archive.Result.OK) {
                Gtk.TreeIter iter;
                string[] path = entry.pathname().split("/");

                if (!model.get_iter_first(out iter)) {
                    model.append(out iter, null);
                    model.set_value(iter, 0, Path.get_basename(filename));
                }

                foreach (unowned string cur in path) {
                    if (cur == "") continue; // skip blank paths

                    if (model.iter_has_child(iter)) {
                        model.iter_children(out iter, iter);
                    }
                    else {
                        model.append(out iter, iter);
                    }

                    while (true) {
                        Value outval;

                        model.get_value(iter, 0, out outval);

                        if (outval.get_string() == null) {
                            model.set(iter, 0, cur, -1);
                            break;
                        }

                        if (outval.get_string() == cur) break;

                        var prev = iter;
                        if (!model.iter_next(ref iter)) {
                            Time time;
                            string size;
                            string mode;
                            string mtime;
                            string birthtime;

                            size      = Utils.format_size(entry.size());
                            mode      = entry.strmode();
                            time      = Time.gm(entry.mtime());
                            mtime     = time.format("%c");
                            time      = Time.gm(entry.birthtime());
                            birthtime = time.format("%c");

                            model.iter_parent(out prev, prev);
                            model.append(out iter, prev);

                            model.set(iter,
                                      FilesColumns.NAME, cur,
                                      FilesColumns.SIZE, size,
                                      FilesColumns.MODE, mode,
                                      FilesColumns.MTIME, mtime,
                                      FilesColumns.BIRTHTIME, birthtime,
                                      -1);
                            break;
                        }
                    }
                }

                archive.read_data_skip();
            }

            main_window.w_tv_files.set_model(model);
        }

        public void add_actions() {
            var quit = new SimpleAction("quit", null);
            var preferences = new SimpleAction("preferences", null);

            preferences.activate.connect(act_preferences);

            quit.activate.connect(() => {
                this.quit();
            });

            this.add_action(quit);
            this.add_action(preferences);
        }

        public void act_preferences() {
            pref_window.show_all();
        }
    }
}
