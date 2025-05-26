
//////////////////////////////////////////////////////////////////////////////////
// MIT License
//
// Copyright (c) 2020 Vicon Motion Systems Ltd
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//////////////////////////////////////////////////////////////////////////////////
#pragma once

/// \file
/// Contains the declaration of the ViconCGStream::VGreyscaleBlobs class.

#include "Item.h"
#include "GreyscaleBlobsDetail.h"
#include <vector>

namespace ViconCGStream
{
//-------------------------------------------------------------------------------------------------

/// Contains a frame of greyscale blobs, along with the camera identifier and frame number.
class VGreyscaleBlobs : public VItem
{
public:

  /// Camera frame number
  ViconCGStreamType::UInt32 m_FrameID;

  /// Camera identifier
  ViconCGStreamType::UInt32 m_CameraID;

  // These members are written to the CG stream in VGreyscaleBlobsSubsampled
  // They will always be used as defaults in this base class
  /// Double the Offset in X
  ViconCGStreamType::UInt16                  m_TwiceOffsetX = 0;
  /// Double the offset in Y
  ViconCGStreamType::UInt16                  m_TwiceOffsetY = 0;
  /// Image pixels per sensor pixel in the X axis (horizontally)
  ViconCGStreamType::UInt8                   m_SensorPixelsPerImagePixelX = 1;
  /// Image pixels per sensor pixel in the Y axis (vertically)
  ViconCGStreamType::UInt8                   m_SensorPixelsPerImagePixelY = 1;


  /// Greyscale blobs
  std::vector< ViconCGStreamDetail::VGreyscaleBlobs_GreyscaleBlob > m_GreyscaleBlobs;

  /// Equality operator 
  bool operator == ( const VGreyscaleBlobs & i_rOther ) const
  {
    return  m_FrameID        == i_rOther.m_FrameID  &&
            m_CameraID       == i_rOther.m_CameraID &&
            m_TwiceOffsetX == i_rOther.m_TwiceOffsetX  &&
            m_TwiceOffsetY == i_rOther.m_TwiceOffsetY &&
            m_SensorPixelsPerImagePixelX == i_rOther.m_SensorPixelsPerImagePixelX &&
            m_SensorPixelsPerImagePixelY == i_rOther.m_SensorPixelsPerImagePixelY &&
            m_GreyscaleBlobs == i_rOther.m_GreyscaleBlobs;
  }

  /// Object type enum.
  virtual ViconCGStreamType::Enum TypeID() const
  {
    return ViconCGStreamEnum::GreyscaleBlobs;
  }
  
  /// Filter ID
  virtual ViconCGStreamType::UInt32 FilterID() const
  {
    return m_CameraID;
  }

  /// Read function. We do not read the subsampled members
  virtual bool Read( const ViconCGStreamIO::VBuffer & i_rBuffer )
  {
    return i_rBuffer.Read( m_FrameID ) &&
           i_rBuffer.Read( m_CameraID ) &&
           i_rBuffer.Read( m_GreyscaleBlobs );
  }
  
  /// Write function. We do not write the subsampled members
  virtual void Write( ViconCGStreamIO::VBuffer & i_rBuffer ) const
  {
    i_rBuffer.Write( m_FrameID );
    i_rBuffer.Write( m_CameraID );
    i_rBuffer.Write( m_GreyscaleBlobs );
  }  

};

//-------------------------------------------------------------------------------------------------
};

