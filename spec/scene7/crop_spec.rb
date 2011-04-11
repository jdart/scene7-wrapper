require 'spec_helper'

describe Scene7::Crop do
  subject { Scene7::Crop }

  describe '.format_url_params' do
    let(:params) { {
      :scale_factor => 0.5,
      :x => 50.0,
      :y => 100.1,
      :height => 149.8,
      :width => 250.2
    } }

    it 'includes the scale and scale factor and defaults the quality to 95' do
      subject.format_url_params(params).should == "scl=0.5&crop=50,100,250,150&qlt=95"
    end

    context "when quality is specified" do
      let(:params) { {
        :scale_factor => 0.5,
        :x => 50.0,
        :y => 100.1,
        :height => 149.8,
        :width => 250.2,
        :quality => 70
      } }

      it "includes the appropriate quality" do
        subject.format_url_params(params).should == "scl=0.5&crop=50,100,250,150&qlt=70"
      end
    end
  end

  describe "conversion methods" do
    let(:params) { {
      :scale_factor => '2.0',
      :x => '100',
      :y => '250',
      :height => '300',
      :width => '450'
    } }

    describe ".convert_from_scale_first_and_format" do
      it "converts, then formats" do
        subject.convert_from_scale_first_and_format(params).should == "scl=0.5&crop=50,125,225,150&qlt=95"
      end

      context "with quality specified" do
        let(:params) { {
          :scale_factor => '2.0',
          :x => '100',
          :y => '250',
          :height => '300',
          :width => '450',
          :quality => '70'
        } }

        it "converts, then formats" do
          subject.convert_from_scale_first_and_format(params).should == "scl=0.5&crop=50,125,225,150&qlt=70"
        end
      end
    end

    describe '.convert_params_from_scale_first' do
      before do
        @result = subject.convert_params_from_scale_first(params)
      end

      it "converts the scale factor from the scale-first style" do
        @result[:scale_factor].should == 0.5
      end

      it "converts the height from the scale-first style" do
        @result[:height].should == 150
      end

      it "converts the width from the scale-first style" do
        @result[:width].should == 225
      end

      it "converts the left coordinate from the scale-first style" do

        @result[:x].should == 50
      end

      it "converts the top coordinate from the scale-first style" do
        @result[:y].should == 125
      end
    end
  end
end
