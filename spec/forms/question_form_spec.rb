require 'rails_helper'

RSpec.describe QuestionForm, type: :form do
  let(:user) { FactoryBot.create(:user) }

  let(:valid_attributes) do
    {
      title: 'テストタイトル',
      user_id: user.id,
      option1_content: '選択肢１の内容',
      option2_content: '選択肢２の内容'
    }
  end

  # --- バリデーションのテスト ---
  describe 'バリデーション' do
    context '有効な属性の場合' do
      it 'フォームオブジェクトが有効であること' do
        form = QuestionForm.new(params: valid_attributes)
        expect(form).to be_valid
      end
    end

    context 'user_id' do
      it 'user_idが存在しない場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(user_id: nil))
        expect(form).to be_invalid
        expect(form.errors[:user_id]).to be_present
      end
    end

    context 'title' do
      it 'titleが存在しない場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(title: nil))
        expect(form).to be_invalid
        expect(form.errors[:title]).to be_present
      end

      it 'titleが空白の場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(title: ''))
        expect(form).to be_invalid
        expect(form.errors[:title]).to be_present
      end

      it 'title29文字を超える場合、無効であること' do
        long_title = 'a' * 30
        form = QuestionForm.new(params: valid_attributes.merge(title: long_title)) # valid_attributesを正しい引数に修正
        expect(form).to be_invalid
        expect(form.errors[:title]).to be_present
      end
    end

    context 'option_contents (選択肢)' do
      it 'option1_contentが存在しない場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(option1_content: nil))
        expect(form).to be_invalid
        expect(form.errors[:option1_content]).to be_present
      end

      it 'option1_contentが空白の場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(option1_content: ''))
        expect(form).to be_invalid
        expect(form.errors[:option1_content]).to be_present
      end

      it 'option1_contentが29文字を超える場合、無効であること' do
        long_content = 'a' * 30
        form = QuestionForm.new(params: valid_attributes.merge(option1_content: long_content))
        expect(form).to be_invalid
        expect(form.errors[:option1_content]).to be_present
      end

      # option2_content のバリデーション
      it 'option2_contentが存在しない場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(option2_content: nil))
        expect(form).to be_invalid
        expect(form.errors[:option2_content]).to be_present
      end

      it 'option2_contentが空白の場合、無効であること' do
        form = QuestionForm.new(params: valid_attributes.merge(option2_content: ''))
        expect(form).to be_invalid
        expect(form.errors[:option2_content]).to be_present
      end

      it 'option2_contentが29文字を超える場合、無効であること' do
        long_content = 'a' * 30
        form = QuestionForm.new(params: valid_attributes.merge(option2_content: long_content))
        expect(form).to be_invalid
        expect(form.errors[:option2_content]).to be_present
      end
    end
  end

  # --- saveメソッドのテスト ---
  describe '#save' do
    context 'フォームオブジェクトが有効な場合' do
      it '新しいQuestionと2つのOptionが作成されること' do
        form = QuestionForm.new(params: valid_attributes)
        expect { form.save }.to change(Question, :count).by(1)
                                .and change(Option, :count).by(2)
        expect(form.errors).to be_empty
      end

      it '作成されたQuestionとOptionの属性が正しいこと' do
        form = QuestionForm.new(params: valid_attributes)
        form.save
        question = Question.last
        options = Option.where(question: question).order(:id)

        expect(question.title).to eq(valid_attributes[:title])
        expect(question.user_id).to eq(user.id)


        expect(options[0].content).to eq(valid_attributes[:option1_content])
        expect(options[1].content).to eq(valid_attributes[:option2_content])
      end

      it 'saveがtrueを返すこと' do
        form = QuestionForm.new(params: valid_attributes)
        expect(form.save).to be true
      end
    end

    context 'フォームオブジェクトが無効な場合' do
      let(:invalid_attributes_no_user_id) { valid_attributes.merge(user_id: nil) }
      it 'user_idがない場合、QuestionもOptionも作成されないこと' do
        form = QuestionForm.new(params: invalid_attributes_no_user_id)
        expect { form.save }.to_not change(Question, :count)
        expect { form.save }.to_not change(Option, :count)
      end

      it 'user_idがない場合、saveがfalseを返すこと' do
        form = QuestionForm.new(params: invalid_attributes_no_user_id)
        expect(form.save).to be false
      end

      it 'user_idがない場合、フォームオブジェクトにuser_idのエラーが設定されること' do
        form = QuestionForm.new(params: invalid_attributes_no_user_id)
        form.save
        expect(form.errors[:user_id]).to be_present
      end

      let(:invalid_attributes_no_title) { valid_attributes.merge(title: nil) }
      it 'titleがない場合、QuestionもOptionも作成されないこと' do
        form = QuestionForm.new(params: invalid_attributes_no_title)
        expect { form.save }.to_not change(Question, :count)
        expect { form.save }.to_not change(Option, :count)
      end

      it 'titleがない場合、saveがfalseを返すこと' do
        form = QuestionForm.new(params: invalid_attributes_no_title)
        expect(form.save).to be false
      end

      it 'titleがない場合、フォームオブジェクトにtitleのエラーが設定されること' do
        form = QuestionForm.new(params: invalid_attributes_no_title)
        form.save
        expect(form.errors[:title]).to be_present
      end

      let(:invalid_attributes_blank_option1_content) { valid_attributes.merge(option1_content: '') }
      it 'option1_contentが空白の場合、QuestionもOptionも作成されないこと' do
        form = QuestionForm.new(params: invalid_attributes_blank_option1_content)
        expect { form.save }.to_not change(Question, :count)
        expect { form.save }.to_not change(Option, :count)
      end

      it 'option1_contentが空白の場合、saveがfalseを返すこと' do
        form = QuestionForm.new(params: invalid_attributes_blank_option1_content)
        expect(form.save).to be false
      end

      it 'option1_contentが空白の場合、フォームオブジェクトにoption1_contentのエラーが設定されること' do
        form = QuestionForm.new(params: invalid_attributes_blank_option1_content)
        form.save
        expect(form.errors[:option1_content]).to be_present
      end

      let(:invalid_attributes_blank_option2_content) { valid_attributes.merge(option2_content: '') }
      it 'option2_contentが空白の場合、QuestionもOptionも作成されないこと' do
        form = QuestionForm.new(params: invalid_attributes_blank_option2_content)
        expect { form.save }.to_not change(Question, :count)
        expect { form.save }.to_not change(Option, :count)
      end

      it 'option2_contentが空白の場合、saveがfalseを返すこと' do
        form = QuestionForm.new(params: invalid_attributes_blank_option2_content)
        expect(form.save).to be false
      end

      it 'option2_contentが空白の場合、フォームオブジェクトにoption2_contentのエラーが設定されること' do
        form = QuestionForm.new(params: invalid_attributes_blank_option2_content)
        form.save
        expect(form.errors[:option2_content]).to be_present
      end
    end
  end
end
