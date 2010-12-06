#-----------------------------------------------------------------------
# Copyright (c) 2010 Chung Shin Yee
#
#       shinyee@speedgocomputing.com
#       http://www.speedgocomputing.com
#       http://github.com/xman/sgc-ruby-cuda
#       http://rubyforge.org/projects/rubycuda
#
# This file is part of SGC-Ruby-CUDA.
#
# SGC-Ruby-CUDA is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SGC-Ruby-CUDA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SGC-Ruby-CUDA.  If not, see <http://www.gnu.org/licenses/>.
#-----------------------------------------------------------------------

require 'test/unit'
require 'rubycuda'

include SGC::Cuda

DEVID = ENV['DEVID'].to_i


class TestRubyCuda < Test::Unit::TestCase

    def test_error
        CudaError.symbols.each do |k|
            s = get_error_string(k)
            assert(s.size > 0)
        end
        e = get_last_error
        s = get_error_string(e)
        assert(s.size > 0)

        e = peek_at_last_error
        s = get_error_string(e)
        assert(s.size > 0)
    end


    def test_version
        dv = driver_version
        rv = runtime_version
        assert(dv > 0)
        assert(rv > 0)
    end


    def test_device_count
        count = CudaDevice.count
        assert(count > 0, "Device count failed.")
    end

    def test_device_get_set
        count = CudaDevice.count
        (0...count).each do |devid|
            r = CudaDevice.set(devid)
            assert_equal(CudaDevice, r)
            d = CudaDevice.get
            assert_equal(devid, d)
        end

        count = CudaDevice.count
        (0...count).each do |devid|
            r = CudaDevice.current = devid
            assert_equal(devid, r)
            d = CudaDevice.current
            assert_equal(devid, d)
        end
    end

    def test_device_choose
        count = CudaDevice.count
        prop = CudaDeviceProp.new
        devid = CudaDevice.choose(prop)
        assert(devid >= 0 && devid < count)
    end

    def test_device_properties
        prop = CudaDevice.properties
        assert_instance_of(CudaDeviceProp, prop)
        # TODO: assert the content of the _prop_.
    end

    def test_device_flags
        CudaDeviceFlags.symbols.each do |k|
            r = CudaDevice.flags = k
            assert_equal(k, r)
            r = CudaDevice.flags = CudaDeviceFlags[k]
            assert_equal(CudaDeviceFlags[k], r)
        end
    end

    def test_device_valid_devices
        count = CudaDevice.count
        devs = []
        (0...count).each do |devid|
            devs << devid
        end
        r = CudaDevice.valid_devices = devs
        assert_equal(devs, r)
    end

end
