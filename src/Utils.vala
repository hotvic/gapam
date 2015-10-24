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
    namespace Utils {
        public string format_size(int64 size) {
            string val;

            val = ("%" + int64.FORMAT + " bytes").printf(size);

            if (size < 1024)                     val = ("%" + int64.FORMAT + " B").printf(size);
            else if (size < Math.pow(1024f, 2f)) val = ("%.2f kB").printf((double) size / 1024f);
            else if (size < Math.pow(1024f, 3f)) val = ("%.2f MB").printf((double) size / Math.pow(1024f, 2f));
            else if (size < Math.pow(1024f, 4f)) val = ("%.2f GB").printf((double) size / Math.pow(1024f, 3f));

            return val;
        }
    }
}
