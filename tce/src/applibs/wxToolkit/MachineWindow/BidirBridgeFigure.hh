/*
    Copyright (c) 2002-2009 Tampere University of Technology.

    This file is part of TTA-Based Codesign Environment (TCE).

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
 */
/**
 * @file BidirBridgeFigure.hh
 *
 * Declaration of BidirBridgeFigure class.
 *
 * @author Ari Metsähalme 2003 (ari.metsahalme-no.spam-tut.fi)
 * @note reviewed Jul 27 2004 by ml, pj, am
 * @note rating: yellow
 */

#ifndef TTA_BIDIR_BRIDGE_FIGURE_HH
#define TTA_BIDIR_BRIDGE_FIGURE_HH

#include <wx/wx.h>

#include "BridgeFigure.hh"

class wxDC;

/**
 * Figure of a bidirectional bridge.
 */
class BidirBridgeFigure : public BridgeFigure {
public:
    BidirBridgeFigure();
    virtual ~BidirBridgeFigure();

protected:
    virtual void drawSelf(wxDC* dc);
    virtual void layoutChildren(wxDC*);

private:
    /// Assignment not allowed.
    BidirBridgeFigure& operator=(BidirBridgeFigure& old);
    /// Copying not allowed.
    BidirBridgeFigure(BidirBridgeFigure& old);
};

#endif
